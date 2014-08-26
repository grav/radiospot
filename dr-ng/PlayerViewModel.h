//
// Created by Mikkel Gravgaard on 15/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kChannelId = @"channelid";
static NSString *const kName = @"name";
static NSString *const kUrl = @"url";


@interface PlayerViewModel : NSObject
@property (nonatomic, readonly) NSArray *channels;
// TODO - eventually this should be read-only
@property (nonatomic) BOOL talkingToSpotify;
@end