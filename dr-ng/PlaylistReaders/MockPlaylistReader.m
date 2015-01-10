//
// Created by Mikkel Gravgaard on 04/01/15.
// Copyright (c) 2015 Betafunk. All rights reserved.
//

#import "MockPlaylistReader.h"
#import "Track.h"


@implementation MockPlaylistReader {

}
- (RACSignal *)currentTrackForChannelWithId:(NSString *)channelId {
    if (drand48() > 0.5) return [RACSignal return:nil];

    id t = [Track trackWithArtist:@"Mr. Very Very Long Name, oh yeah, and his last name is not McCartney but something even longer" title:@"Some quite long title, which is very long!"];
    return [RACSignal return:t];
}

@end