//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PlayerViewController.h"
#import "CocoaLibSpotify.h"
#include "appkey.c"
#import "FallbackPlaylistReader.h"
#import "ChannelCell.h"
#import "PlaylistReader.h"
#import "WBSuccessNoticeView.h"
#import "WBErrorNoticeView.h"

static NSString *const kChannelId = @"channelid";

static NSString *const kPlaylistName = @"dr-ng";

@interface PlayerViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) id<Playlist> playlist;
@property(nonatomic, strong) UIButton *addToSpotBtn;
@end

@implementation PlayerViewController {

}
NSString *const SpotifyUsername = @"113192706";

- (instancetype)init{
    self = [super init];
    if(self){
        self.playlist = [[PlaylistReader alloc] init]; // TODO - use fallback if it fails

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
        [self spotifyLogin];

        self.channels = @[
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
                }
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    RACSignal *currentTrackS = RACObserve(self.playlist, currentTrack);


    self.addToSpotBtn = [UIButton new];
    self.addToSpotBtn.rac_command = [[RACCommand alloc] initWithEnabled:[currentTrackS map:^id(id track) {
        return @(track!=nil);
    }] signalBlock:^RACSignal *(id input) {
        [self addTrack:self.playlist.currentTrack];
        return [RACSignal empty];
    }];
    [self.addToSpotBtn setTitle:@"Add to Spotify" forState:UIControlStateNormal];
    [self.addToSpotBtn setTitleColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.addToSpotBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];

    [self.view addSubview:self.addToSpotBtn];
    [self.addToSpotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(10);
        make.height.equalTo(@50);
    }];

    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addToSpotBtn.mas_top).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(10);
        make.height.equalTo(@50);
    }];

    RAC(label,text) = [currentTrackS map:^id(NSDictionary *track) {
        return track ? [NSString stringWithFormat:@"%@ - %@", track[kArtist], track[kTitle]] : @"";
    }];

    UITableView *tableView = [UITableView new];
    tableView.dataSource = self; tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(label.mas_top);
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

- (void)addTrack:(NSDictionary *)track
{
    self.addToSpotBtn.enabled = NO;
    NSString *searchQuery = [NSString stringWithFormat:@"%@ %@",track[kArtist],track[kTitle]];
    NSLog(@"searching spotify for '%@'...",searchQuery);

    SPSearch *search = [SPSearch searchWithSearchQuery:searchQuery inSession:[SPSession sharedSession]];
    SPPlaylistContainer *playlistContainer = [[SPSession sharedSession] userPlaylists];
    [SPAsyncLoading waitUntilLoaded:@[
            search,
            playlistContainer]
                            timeout:10 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {

        if(!search.tracks.count) {
            NSLog(@"no search results");
            return;
        }

        [SPAsyncLoading waitUntilLoaded:playlistContainer.flattenedPlaylists timeout:10 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            __block SPPlaylist *foundPlaylist;
            [playlistContainer.flattenedPlaylists enumerateObjectsUsingBlock:^(SPPlaylist *playlist, NSUInteger idx, BOOL *stop) {
                if ([playlist.name isEqualToString:kPlaylistName]) {
                    foundPlaylist = playlist;
                    *stop = YES;
                }
            }];
            void (^addItem)(SPPlaylist *) = ^(SPPlaylist *playlist) {
                [playlist addItem:search.tracks.firstObject atIndex:0 callback:^(NSError *error) {
                    if(!error){
                        [[WBSuccessNoticeView successNoticeInView:self.view title:@"Added track to playlist"] show];
                    } else {
                        [[WBErrorNoticeView errorNoticeInView:self.view title:@"Problem adding track" message:[error description]] show];
                    }

                    NSLog(@"%@", error?error:@"added track to playlist");
                    self.addToSpotBtn.enabled = YES;
                }];

            };
            if(!foundPlaylist){
                NSLog(@"creating playlist %@",kPlaylistName);
                [playlistContainer createPlaylistWithName:kPlaylistName callback:addItem];
            } else {
                addItem(foundPlaylist);
            }
        }];
    }];

}

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession {

    NSLog(@"logged in!");

}

@end