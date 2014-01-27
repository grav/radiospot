//
// Created by Mikkel Gravgaard on 26/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ChannelP2,
    ChannelP3,
    ChannelP6Beat,
    ChannelP7Mix,
    ChannelP8Jazz
} Channel;

static NSString *const kTitle = @"title";
static NSString *const kArtist = @"artist";


@protocol Playlist <NSObject>
@property (nonatomic) Channel channel;
@property (nonatomic, copy, readonly) NSDictionary *currentTrack;
@end