//
// Created by Mikkel Gravgaard on 15/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlayerViewModel.h"
#import "Channel.h"


static NSString *const kTracksAdded = @"TracksAdded";

static NSString *const kAddUsingRemote = @"didAddUsingRemote";

@interface PlayerViewModel ()
@property (nonatomic, strong) NSArray *channels;
@end

@implementation PlayerViewModel {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    _tracksAdded = [[NSUserDefaults standardUserDefaults] integerForKey:kTracksAdded];
    _didAddUsingRemove = [[NSUserDefaults standardUserDefaults] boolForKey:kAddUsingRemote];
    return self;
}


- (void)setTracksAdded:(int)tracksAdded {
    _tracksAdded = tracksAdded;
    [[NSUserDefaults standardUserDefaults] setInteger:tracksAdded forKey:kTracksAdded];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDidAddUsingRemove:(BOOL)didAddUsingRemote {
    _didAddUsingRemove = didAddUsingRemote;
    [[NSUserDefaults standardUserDefaults] setBool:didAddUsingRemote forKey:kAddUsingRemote];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSArray *)channels {
    if (!_channels) {
        _channels = @[
                MakeChannel(@"P1", @"P1", PlaylistReaderTypeDR, @"http://drradio1-lh.akamaihd.net/i/p1_9@143503/master.m3u8"),
                MakeChannel(@"P2", @"P2", PlaylistReaderTypeDR, @"http://drradio2-lh.akamaihd.net/i/p2_9@143504/master.m3u8"),
                MakeChannel(@"P3", @"P3", PlaylistReaderTypeDR, @"http://drradio3-lh.akamaihd.net/i/p3_9@143506/master.m3u8"),
                MakeChannel(@"P5", @"P5D", PlaylistReaderTypeDR, @"http://drradio1-lh.akamaihd.net/i/p5_9@143530/master.m3u8"),
                MakeChannel(@"P6 Beat", @"P6B", PlaylistReaderTypeDR, @"http://drradio3-lh.akamaihd.net/i/p6beat_9@143533/master.m3u8"),
                MakeChannel(@"P7 Mix", @"P7M", PlaylistReaderTypeDR, @"http://drradio1-lh.akamaihd.net/i/p7mix_9@143522/master.m3u8"),
                MakeChannel(@"P8 Jazz", @"P8J", PlaylistReaderTypeDR, @"http://drradio2-lh.akamaihd.net/i/p8jazz_9@143524/master.m3u8"),
                MakeChannel(@"DR MAMA", @"DRM", PlaylistReaderTypeDR, @"http://drradio3-lh.akamaihd.net/i/drmama_9@143520/master.m3u8"),
                MakeChannel(@"DR Ramasjang/Ultra Radio", @"Ram", PlaylistReaderTypeDR, @"http://drradio3-lh.akamaihd.net/i/ramasjang_9@143529/master.m3u8"),
                MakeChannel(@"DR Nyheder", nil, PlaylistReaderTypeDR, @"http://drradio2-lh.akamaihd.net/i/drnyheder_9@143532/master.m3u8")
        ];
    }
    return _channels;
}

@end