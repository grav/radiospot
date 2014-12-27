//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"

@class Channel;
@protocol PlaylistReader;


@interface PlaylistHelper : NSObject

+ (RACSignal *)currentTrackForChannel:(Channel *)c;
@end