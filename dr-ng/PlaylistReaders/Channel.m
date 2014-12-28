//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "Channel.h"


@implementation Channel {

}

+ (instancetype)channelWithName:(NSString *)name id:(id)channelId readerType:(PlaylistReaderType)readerType urlString:(NSString *)urlString broadcaster:(NSString *)broadcaster {
    Channel *c = [Channel new];
    c->_channelId = channelId;
    c->_name = name;
    c->_playlistReaderType = readerType;
    c->_playbackURL = [NSURL URLWithString:urlString];
    c->_broadcaster = broadcaster;
    return c;
}

- (NSUInteger)hash {
    return [self.name hash] * 3 + [self.playbackURL hash] * 5 + self.playlistReaderType * 7;
}

- (BOOL)isEqual:(Channel *)other {
    return [self.playbackURL isEqual:other.playbackURL] && [self.name isEqualToString:other.name] && self.playlistReaderType == other.playlistReaderType;
}


@end

