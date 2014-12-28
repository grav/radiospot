//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//


@protocol PlaylistReader <NSObject>
- (RACSignal *)currentTrackForChannelWithId:(NSString *)channelId;
@end

