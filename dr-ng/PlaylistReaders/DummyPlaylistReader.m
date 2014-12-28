//
// Created by Mikkel Gravgaard on 28/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "DummyPlaylistReader.h"


@implementation DummyPlaylistReader {

}
- (RACSignal *)currentTrackForChannelWithId:(NSString *)channelId {
    return [RACSignal return:nil];
}

@end