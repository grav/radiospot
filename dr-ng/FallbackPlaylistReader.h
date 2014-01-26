//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playlist.h"

@class RACSignal;
static NSString *const kP6Beat = @"p6beat";
static NSString *const kP3 = @"p3";

@interface FallbackPlaylistReader : NSObject<Playlist>

@end