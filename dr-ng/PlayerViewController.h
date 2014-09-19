//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSession.h"
static NSString *const kTracklistId = @"tracklistUrl";
static NSString *const kFallbackTracklistId = @"fallbackId";

@class SPPlaybackManager;
@class AVPlayer;
@class BTFSpotify;
@class PlayerView;


@interface PlayerViewController : UIViewController
@end