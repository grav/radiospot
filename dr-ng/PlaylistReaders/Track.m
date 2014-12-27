//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "Track.h"
#import "Channel.h"
#import "DanmarksRadio.h"
#import "RadioPlay.h"


@implementation Track {

}
+ (instancetype)trackWithArtist:(NSString *)artist title:(id)title {
    Track *t = [Track new];
    t->_artist = artist;
    t->_title = title;
    return t;
}
@end