//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlaylistHelper.h"
#import "PlaylistReader.h"
#import "DanmarksRadio.h"
#import "RadioPlay.h"


@implementation PlaylistHelper {

}
// Type -> Instance
+ (id <PlaylistReader>)readerForReaderType:(PlaylistReaderType)t {
    switch (t){
        case PlaylistReaderTypeDR:
            return [DanmarksRadio new];
        case PlaylistReaderTypeRadioPlay:
            return [RadioPlay new];
    }
    NSCAssert(false, @"");
    return nil;
}

+ (RACSignal *)currentTrackForChannel:(Channel *)c {
    id<PlaylistReader> reader = [PlaylistHelper readerForReaderType:c.playlistReaderType];
    return c.channelId ? [reader currentTrackForChannelWithId:c.channelId] : [RACSignal return:nil];
};

@end