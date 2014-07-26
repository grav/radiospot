//
// Created by Mikkel Gravgaard on 26/07/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <NSArray+Functional/NSArray+Functional.h>
#import <CocoaLibSpotify/SPSession.h>
#import <CocoaLibSpotify/SPPlaylist.h>
#include "appkey.c"
#import "SPPlaybackManager.h"
#import "BTFSpotify.h"
#import "SPPlaylistContainer.h"
#import "SPLoginViewController.h"

@interface BTFSpotify () <SPSessionDelegate>
@property (nonatomic, strong) SPPlaybackManager *playbackManager;
@property(nonatomic) BOOL wantsPresentingViewController;
@end

@implementation BTFSpotify {

}

- (SPPlaybackManager *)playbackManager {
    if(!_playbackManager && [SPSession sharedSession]){
        _playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    }
    return _playbackManager;
}


- (RACSignal *)session{
    return [[[RACSignal return:[SPSession sharedSession]] flattenMap:^RACStream *(SPSession *session) {
        if (session) {
            return [RACSignal return:session];
        } else {
            NSError *error;

            BOOL result = [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey
                                                                                              length:g_appkey_size]
                                                                     userAgent:@"dk.betafunk.splif"
                                                                 loadingPolicy:SPAsyncLoadingManual
                                                                         error:&error];
            NSCAssert(result, @"");
            // TODO - might want to handle error nicer here


            NSLog(@"Logging in...");
            session = [SPSession sharedSession];
            session.delegate = self;

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *storedCredentials = [defaults valueForKey:@"SpotifyUsers"];
            id key = [[storedCredentials allKeys] firstObject];

            // TODO - handle case where storedCredentials is too old!
            if (key) {
                NSString *pw = storedCredentials[key];
                [session attemptLoginWithUserName:key existingCredential:pw];
            } else {
                // TODO - handle case where user cancels - we'll never complete then!
                self.wantsPresentingViewController = YES;
                [[[RACObserve(self, presentingViewController) ignore:nil] delay:1] subscribeNext:^(UIViewController *presentingVC) {
                    UIViewController *loginVC = [SPLoginViewController loginControllerForSession:session];
                    [presentingVC presentViewController:loginVC animated:YES completion:nil];
                }];
            }
            RACSignal *didSucceed = [[self rac_signalForSelector:@selector(sessionDidLoginSuccessfully:)] flattenMap:^RACStream *(RACTuple *tuple) {
                return [self load:tuple.first];
            }];
            RACSignal *didFail = [[self rac_signalForSelector:@selector(session:didFailToLoginWithError:)] flattenMap:^RACStream *(RACTuple *tuple) {
                return [RACSignal error:tuple.second];
            }];

            return [RACSignal merge:@[didSucceed, didFail]];
        }
    }] replayLazily];
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error {
    NSLog(@"session failed login: %@",error);
}



- (void)sessionDidLoginSuccessfully:(SPSession *)aSession {
    NSLog(@"Spotify logged in");
}

- (RACSignal *)starredPlaylist
{
    return [self.session flattenMap:^RACStream *(SPSession *session) {
        return [self load:session.starredPlaylist];
    }];
}

- (RACSignal *)playlistWithName:(NSString *)name{
    return [[[self.session flattenMap:^id(SPSession *session) {
        return [self load:session.userPlaylists];
    }] flattenMap:^id(SPPlaylistContainer *playlistContainer) {
        return [self load:playlistContainer.flattenedPlaylists];
    }] map:^id(NSArray *playlists) {
        // TODO - do we have to go out of RAC domain here?
        return [[playlists filterUsingBlock:^BOOL(SPPlaylist *playlist) {
            return [playlist.name isEqualToString:name];
        }] firstObject];
    }];

}

- (RACSignal *)addItem:(SPTrack *)item toPlaylist:(SPPlaylist *)playlist atIndex:(NSUInteger)idx{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [playlist addItem:item atIndex:idx
                 callback:^(NSError *error) {
            if(error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:@YES];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)createPlaylist:(NSString *)playlistName
{
    return [[self playlistContainer] flattenMap:^RACStream *(SPPlaylistContainer *container) {
        return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
            [container createPlaylistWithName:playlistName callback:^(SPPlaylist *createdPlaylist) {
                [subscriber sendNext:createdPlaylist];
            }];
            return nil;
        }];
    }];

}

- (RACSignal *)playlistContainer
{
    return [self.session flattenMap:^RACStream *(SPSession *s) {
            return [self load:s.userPlaylists];
    }];
}

- (RACSignal *)allPlaylists
{
    return [[self playlistContainer] flattenMap:^RACStream *(SPPlaylistContainer *container) {
        return [self load:container.flattenedPlaylists];
    }];
}

- (RACSignal *)search:(NSString *)query
{
    return [self.session flattenMap:^RACStream *(SPSession *s) {
        SPSearch *search = [SPSearch searchWithSearchQuery:query inSession:s];
        return [self load:search];
    }];
}

- (RACSignal *)load:(id)thing{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [SPAsyncLoading waitUntilLoaded:thing timeout:kSPAsyncLoadingDefaultTimeout
                                   then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                                       if(loadedItems.count==1){
                                            [subscriber sendNext:loadedItems.firstObject];
                                       } else if(loadedItems.count>1){
                                           [subscriber sendNext:loadedItems];
                                       } else {
                                           NSCAssert(notLoadedItems.count>0,@"");
                                           NSString *string = [NSString stringWithFormat:@"Could not load %@",thing];
                                           NSError *error = [NSError errorWithDomain:@"btf.spotify"
                                                                                code:-1
                                                                            userInfo:@{NSLocalizedDescriptionKey:string}];
                                           [subscriber sendError:error];
                                       }
                                   }];
        return nil;
    }];
}




- (void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName {
    NSLog(@"didGenerateLoginCreds");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *storedCredentials = [[defaults valueForKey:@"SpotifyUsers"] mutableCopy];

    if (storedCredentials == nil)
        storedCredentials = [NSMutableDictionary dictionary];

    [storedCredentials setValue:credential forKey:userName];
    [defaults setValue:storedCredentials forKey:@"SpotifyUsers"];
}


@end