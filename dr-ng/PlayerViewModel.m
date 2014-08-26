//
// Created by Mikkel Gravgaard on 15/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlaylistReader.h"
#import "PlayerViewModel.h"


@interface PlayerViewModel ()
@property (nonatomic, strong) NSArray *channels;
@end

@implementation PlayerViewModel {

}

- (NSArray *)channels {
    if(!_channels){
        _channels = @[
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
                                kChannelId:@(ChannelDRNyheder)

                        },
                ];
    }
    return _channels;

}

@end