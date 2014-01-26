//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PlayerViewController.h"
#import "CocoaLibSpotify.h"
#include "appkey.c"
#import "ReactiveCocoa.h"
#import "FallbackPlaylistReader.h"
#import "ChannelCell.h"
#import "Playlist.h"

static NSString *const kTracklistUrl = @"http://www.dr.dk/info/musik/service/TrackInfoJsonService.svc/TrackInfo/%@";

static NSString *const kChannelId = @"channelid";

@interface PlayerViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) SPPlaybackManager *playbackManager;
@property(nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) id<Playlist> playlist;
@end

@implementation PlayerViewController {

}
NSString *const SpotifyUsername = @"113192706";

- (instancetype)init{
    self = [super init];
    if(self){
        self.playlist = [[FallbackPlaylistReader alloc] init]; // TODO - first try creating regular playlistReader

        [RACObserve(self.playlist, currentTrack) subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];

//        NSError *error = nil;
//       	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
//       											   userAgent:@"dk.betafunk.splif"
//       										   loadingPolicy:SPAsyncLoadingManual
//       												   error:&error];
//       	if (error != nil) {
//       		NSLog(@"CocoaLibSpotify init failed: %@", error);
//       		abort();
//       	}
//        [SPSession sharedSession].delegate = self;

//        NSOperation *op = [[DRPChannelUpdateOperation alloc] init];
//        [op start];
//
//        [[NSNotificationCenter defaultCenter] addObserverForName:ChannelUpdateOperationDidFinish object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//            NSArray *channels = note.object;
//            self.channels = [channels.rac_sequence filter:^BOOL(DRPChannel *channel) {
//                return channel.type == DRPChannelRadioType;
//            }].array;
//            DRPChannel *channel = self.channels[0];
//            self.player = [AVPlayer playerWithURL:channel.streamQualityHighURL];
//            [self.player play];
//
//        }];
        self.channels = @[
                @{
                        kName:@"P2",
                        kUrl :@"http://drradio2-lh.akamaihd.net/i/p2_9@143504/master.m3u8",
                        kTracklistId : @"P2",
                        kChannelId :@(ChannelP2)
                },
                @{
                        kName:@"P6 Beat",
                        kUrl:@"http://drradio3-lh.akamaihd.net/i/p6beat_9@143533/master.m3u8",
                        kChannelId:@(ChannelP6Beat),
                        kTracklistId:@"P6B",
                        kFallbackTracklistId :@"p6beat"
                },
                @{
                        kName:@"P8 Jazz",
                        kUrl:@"http://drradio2-lh.akamaihd.net/i/p8jazz_9@143524/master.m3u8",
                        kChannelId:@(ChannelP8Jazz),
                        kTracklistId:@"P8J",
                }
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [UITableView new];
    tableView.dataSource = self; tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).dividedBy(2);
    }];

}

#pragma mark tblview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseId];
    if(!cell){
        cell = [ChannelCell new];
    }
    [cell configure:self.channels[(NSUInteger) indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *channel = self.channels[(NSUInteger) indexPath.row];
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:channel[kUrl]]];
    [self.player play];
    self.playlist.channel = (Channel) ((NSNumber*)(channel[kChannelId])).integerValue;
}


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
    
//    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
//    RACSignal *trackSignal = [FallbackPlaylistReader trackSignalForChannel:kP3];
//
//    [trackSignal subscribeNext:^(RACTuple *tuple) {
//        RACTupleUnpack(NSString *trackName, NSString *artist,NSString *time) = tuple;
//        NSLog(@"Found new: %@ - %@",artist, trackName);
//        NSString *searchQuery = [NSString stringWithFormat:@"%@ %@",artist,trackName];
//
//        SPSearch *search = [SPSearch searchWithSearchQuery:searchQuery inSession:[SPSession sharedSession]];
//        [SPAsyncLoading waitUntilLoaded:search timeout:10 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
//            NSLog(@"Playing first of search results: %@",search.tracks);
//            [self.playbackManager playTrack:search.tracks.firstObject callback:^(NSError *error) {
//                if (error) NSLog(@"error: %@", error);
//            }];
//
//            NSLog(@"%@",search.tracks);
//        }];
//    } error:^(NSError *error) {
//        NSLog(@"error: %@",error);
//    } completed:^{
//        NSLog(@"completed");
//    }];


}

@end