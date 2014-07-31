//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSession.h"
static NSString *const kName = @"name";
static NSString *const kUrl = @"url";
static NSString *const kTracklistId = @"tracklistUrl";
static NSString *const kFallbackTracklistId = @"fallbackId";

@class SPPlaybackManager;
@class AVPlayer;
@class BTFSpotify;


@interface PlayerViewController : UIViewController
- (BOOL)isPlaying;
@end