//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PlayerViewController.h"
#import "CocoaLibSpotify.h"
#include "appkey.c"
#import "ReactiveCocoa.h"
#import "PlaylistReader.h"
#import "DRPChannelUpdateOperation.h"
#import "DRPConstants.h"
#import "DRPChannel.h"

@interface PlayerViewController ()
@property(nonatomic, strong) SPPlaybackManager *playbackManager;
@property(nonatomic, strong) AVPlayer *player;
@end

@implementation PlayerViewController {

}
NSString *const SpotifyUsername = @"113192706";

- (instancetype)init{
    self = [super init];
    if(self){
        NSError *error = nil;
       	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
       											   userAgent:@"dk.betafunk.splif"
       										   loadingPolicy:SPAsyncLoadingManual
       												   error:&error];
       	if (error != nil) {
       		NSLog(@"CocoaLibSpotify init failed: %@", error);
       		abort();
       	}
        [SPSession sharedSession].delegate = self;

//        if([SPSession sharedSession].connectionState != SP_CONNECTION_STATE_LOGGED_IN){
//            [self performSelector:@selector(spotifyLogin) withObject:nil afterDelay:2];
//        }


        NSOperation *op = [[DRPChannelUpdateOperation alloc] init];
        [op start];

        [[NSNotificationCenter defaultCenter] addObserverForName:ChannelUpdateOperationDidFinish object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            DRPChannel *channel = ((NSArray *)note.object).firstObject;
            self.player = [[AVPlayer alloc] initWithURL:channel.streamQualityHighURL];
            [self.player play];
        }];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - drplay

#pragma mark spot

- (void)spotifyLogin {
    NSError *error;
    NSString *passwordFilePath = [NSString stringWithFormat:@"%@/spotify_password.txt",[[NSBundle mainBundle] resourcePath]];
    NSString *spotifyPassword = [NSString stringWithContentsOfFile:passwordFilePath encoding:NSUTF8StringEncoding error:&error];
    NSCAssert(!error,@"Error reading from %@: %@", passwordFilePath,error);
    NSLog(@"Logging in...");
    [[SPSession sharedSession] attemptLoginWithUserName:SpotifyUsername
                                    password:spotifyPassword];
}

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession {
    NSLog(@"logged in");
    
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    RACSignal *trackSignal = [PlaylistReader trackSignalForChannel:kP3];

    [trackSignal subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSString *trackName, NSString *artist,NSString *time) = tuple;
        NSLog(@"Found new: %@ - %@",artist, trackName);
        NSString *searchQuery = [NSString stringWithFormat:@"%@ %@",artist,trackName];

        SPSearch *search = [SPSearch searchWithSearchQuery:searchQuery inSession:[SPSession sharedSession]];
        [SPAsyncLoading waitUntilLoaded:search timeout:10 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            NSLog(@"Playing first of search results: %@",search.tracks);
            [self.playbackManager playTrack:search.tracks.firstObject callback:^(NSError *error) {
                if (error) NSLog(@"error: %@", error);
            }];

            NSLog(@"%@",search.tracks);
        }];
    } error:^(NSError *error) {
        NSLog(@"error: %@",error);
    } completed:^{
        NSLog(@"completed");
    }];


}

@end