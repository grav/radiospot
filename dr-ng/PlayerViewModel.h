//
// Created by Mikkel Gravgaard on 15/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Track;
@class Channel;

@interface PlayerViewModel : NSObject
@property (nonatomic, readonly) NSArray *channels;
// TODO - eventually this should be read-only
@property (nonatomic) BOOL talkingToSpotify;
@property(nonatomic) BOOL userPaused;
@property (nonatomic, strong) Channel *currentChannel;
@property (nonatomic, strong) Track *currentTrack;

@property(nonatomic) BOOL didDismissMessage;
@property(nonatomic) int tracksAdded;
@property(nonatomic) BOOL didAddUsingRemove;

- (void)moveChannelFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
@end