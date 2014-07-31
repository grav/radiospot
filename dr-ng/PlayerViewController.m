//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PlayerViewController.h"
#import "CocoaLibSpotify.h"
#import "FallbackPlaylistReader.h"
#import "ChannelCell.h"
#import "PlaylistReader.h"
#import "WBSuccessNoticeView.h"
#import "WBErrorNoticeView.h"
#import "BTFSpotify.h"
#import <MediaPlayer/MediaPlayer.h>
#include "appkey.c"

static NSString *const kChannelId = @"channelid";

static NSString *const kPlaylistName = @"RadioSpot";

@interface PlayerViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) id<Playlist> playlist;
@property(nonatomic, strong) UIButton *addToSpotBtn;
@property (nonatomic, strong) AVAudioPlayer *spotifyAddingSuccessPlayer;
@property(nonatomic, strong) BTFSpotify *btfSpotify;
@end

@implementation PlayerViewController {

}

- (instancetype)init{
    self = [super init];
    if(self){

        RACSignal *remoteControlSignal = [[self rac_signalForSelector:@selector(remoteControlReceivedWithEvent:)] map:^id(RACTuple *tuple) {
            return tuple.first;
        }];

        [[remoteControlSignal filter:^BOOL(UIEvent *event) {
            return event.subtype == UIEventSubtypeRemoteControlPreviousTrack;
        }] subscribeNext:^(id x) {
            if(self.playlist.currentTrack){
                [self addTrack:self.playlist.currentTrack];
            }
        }];


        self.playlist = [PlaylistReader new]; // TODO - use fallback if it fails

        self.channels = @[
                @{
                        kName:@"P1",
                        kUrl :@"http://drradio1-lh.akamaihd.net/i/p1_9@143503/master.m3u8",
                        kChannelId :@(ChannelP1)
                },
                @{
                        kName:@"P2",
                        kUrl :@"http://drradio2-lh.akamaihd.net/i/p2_9@143504/master.m3u8",
                        kChannelId :@(ChannelP2)
                },
                @{
                        kName:@"P3",
                        kUrl :@"http://drradio3-lh.akamaihd.net/i/p3_9@143506/master.m3u8",
                        kChannelId :@(ChannelP3)
                },
                @{
                        kName:@"P5",
                        kUrl :@"http://drradio1-lh.akamaihd.net/i/p5_9@143530/master.m3u8",
                        kChannelId :@(ChannelP5)
                },
                @{
                        kName:@"P6 Beat",
                        kUrl:@"http://drradio3-lh.akamaihd.net/i/p6beat_9@143533/master.m3u8",
                        kChannelId:@(ChannelP6Beat),
                },
                @{
                        kName:@"P7 Mix",
                        kUrl:@"http://drradio1-lh.akamaihd.net/i/p7mix_9@143522/master.m3u8",
                        kChannelId:@(ChannelP7Mix),
                },
                @{
                        kName:@"P8 Jazz",
                        kUrl:@"http://drradio2-lh.akamaihd.net/i/p8jazz_9@143524/master.m3u8",
                        kChannelId:@(ChannelP8Jazz)
                },
                @{
                        kName:@"DR MAMA",
                        kUrl:@"http://drradio3-lh.akamaihd.net/i/drmama_9@143520/master.m3u8",
                        kChannelId:@(ChannelDRMama)

                },
                @{
                        kName:@"DR Ramasjang/Ultra Radio",
                        kUrl:@"http://drradio3-lh.akamaihd.net/i/ramasjang_9@143529/master.m3u8",
                        kChannelId:@(ChannelRamasjang)

                },
                @{
                        kName:@"DR Nyheder",
                        kUrl:@"http://drradio2-lh.akamaihd.net/i/drnyheder_9@143532/master.m3u8",
                        kChannelId:@(ChannelP8Jazz)

                },
        ];
        
        self.btfSpotify = [[BTFSpotify alloc] initWithAppKey:g_appkey size:g_appkey_size];
        self.btfSpotify.presentingViewController = self;


    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    RACSignal *currentTrackS = RACObserve(self.playlist, currentTrack);

    UITableView *tableView = [UITableView new];
    tableView.dataSource = self; tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];

    RAC(label,text) = [[currentTrackS map:^id(NSDictionary *track) {
        return track ? [NSString stringWithFormat:@"%@ - %@", track[kArtist], track[kTitle]] : @" ";
    }] doNext:^(NSString *s) {
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
                 MPMediaItemPropertyTitle : s
        }];
    }];



    self.addToSpotBtn = [UIButton new];
    self.addToSpotBtn.rac_command = [[RACCommand alloc] initWithEnabled:[currentTrackS map:^id(id track) {
        return @(track!=nil);
    }] signalBlock:^RACSignal *(id input) {
        [self addTrack:self.playlist.currentTrack];
        return [RACSignal empty];
    }];
    [self.addToSpotBtn setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [self.addToSpotBtn setTitle:@"Add to Spotify" forState:UIControlStateNormal];
    [self.addToSpotBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [self.addToSpotBtn setTitleColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.addToSpotBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];

    [self.view addSubview:self.addToSpotBtn];
    [self.addToSpotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
    }];


    [[RACSignal interval:4 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@",(__bridge NSString *)CMTimeCopyDescription(NULL, self.player.currentTime));
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

- (void)playChannel:(NSDictionary*)channel
{
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:channel[kUrl]]];
#if DEBUG
    [self startLogging];
#endif

    [self.player play];


    [[[RACObserve(self.player.currentItem, playbackLikelyToKeepUp) throttle:4] ignore:@YES]
            subscribeNext:^(id x) {
                NSLog(@"===== buffer empty- lets restart =====");
                [[WBErrorNoticeView errorNoticeInView:self.view title:@"Trying to restart" message:nil] show];
                
                [self performSelector:@selector(playChannel:) withObject:channel afterDelay:1];
    }];

}

- (void)startLogging {
    [@[@"status", @"rate", @"currentItem", @"error", @"currentTime"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[self.player rac_valuesForKeyPath:obj observer:self.player] subscribeNext:^(id x) {
            NSLog(@"%@: %@",obj,x);
        }];
    }];

    [@[@"error", @"status", @"playbackBufferEmpty", @"playbackBufferFull", @"playbackLikelyToKeepUp"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[self.player.currentItem rac_valuesForKeyPath:obj
                                              observer:self.player.currentItem] subscribeNext:^(id x) {
            NSLog(@"currentItem %@: %@",obj,x);
        }];
    }];


    [[RACObserve(self.player.currentItem, loadedTimeRanges) map:^id(NSArray *timeranges) {
        CMTimeRange range = [timeranges.firstObject CMTimeRangeValue];
        return @(CMTimeGetSeconds(range.duration));
    }] subscribeNext:^(id x) {
        NSLog(@"duration: %@",x);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *channel = self.channels[(NSUInteger) indexPath.row];
    self.playlist.channel = (Channel) ((NSNumber*)(channel[kChannelId])).integerValue;
    [self playChannel:channel];

}

- (void)stop:(UIButton *)sender
{
    sender.hidden = YES;
    [self.player pause];
    self.player = nil;
}

#pragma mark spot

- (void)addTrack:(NSDictionary *)track
{
    self.addToSpotBtn.enabled = NO;
    NSString *searchQuery = [NSString stringWithFormat:@"%@ %@",track[kArtist],track[kTitle]];
    NSLog(@"searching spotify for '%@'...",searchQuery);

    RACSignal *playlist = [[self.btfSpotify playlistWithName:kPlaylistName] flattenMap:^RACStream *(SPPlaylist *playlist1) {
        return playlist1 ? [RACSignal return:playlist1] : [self.btfSpotify createPlaylist:kPlaylistName];
    }];

    RACSignal *trackAdded = [[self.btfSpotify search:searchQuery] flattenMap:^RACStream *(SPSearch *search) {
        return [playlist flattenMap:^RACStream *(SPPlaylist *playlist1) {
            return [self.btfSpotify addItem:search.tracks.firstObject
                                 toPlaylist:playlist1
                                    atIndex:0];
        }];
    }];

    [trackAdded subscribeNext:^(id x) {
        NSString *info = [NSString stringWithFormat:@"Added track to playlist '%@'", kPlaylistName];
        [[WBSuccessNoticeView successNoticeInView:self.view title:info] show];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"success" withExtension:@"wav"];
            [self playSound:url];
        }
        NSLog(@"added track to playlist");
        self.addToSpotBtn.enabled = YES;

    } error:^(NSError *error) {
        [[WBErrorNoticeView errorNoticeInView:self.view title:@"Problem adding track"
                                      message:[error description]] show];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"fail" withExtension:@"wav"];
            [self playSound:url];
        }
        NSLog(@"%@", error);
        self.addToSpotBtn.enabled = YES;

    }];

}

- (void)playSound:(NSURL *)url {
    NSError *error;
    self.spotifyAddingSuccessPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                                             error:&error];
    [self.spotifyAddingSuccessPlayer play];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
}

- (BOOL)isPlaying {
    return self.player!=nil;
}
@end