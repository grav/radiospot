//
// Created by Mikkel Gravgaard on 26/07/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPPlaybackManager;


@interface BTFSpotify : NSObject
@property (nonatomic, readonly) SPPlaybackManager *playbackManager;
@property(nonatomic, readonly) BOOL wantsPresentingViewController;
@property (nonatomic, weak) UIViewController *presentingViewController;

- (RACSignal *)starredPlaylist;

- (RACSignal *)playlistWithName:(NSString *)name;

- (RACSignal *)addItem:(SPTrack *)item toPlaylist:(SPPlaylist *)playlist atIndex:(NSUInteger)idx;

- (RACSignal *)createPlaylist:(NSString *)playlistName;

- (RACSignal *)allPlaylists;

- (RACSignal *)search:(NSString *)query;

- (RACSignal *)load:(id)thing;
@end