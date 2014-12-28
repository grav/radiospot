//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "RadioPlay.h"
#import "Track.h"

static NSString *RadioPlay_PlaylistURL = @"http://static.radioplay.dk/data/all_dk.jsonp";

@implementation RadioPlay {

}

+ (RACSignal *)currentPlaylists
{

    return [[[[[[RACSignal return:nil] deliverOn:[RACScheduler scheduler]] map:^id(id _) {
        NSURL *url = [NSURL URLWithString:RadioPlay_PlaylistURL];
        NSError *error;
        NSString *s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        return s;
    }] map:^id(NSString *s) {
        return [[s
                stringByReplacingOccurrencesOfString:@"onair_callback(" withString:@""]
                stringByReplacingOccurrencesOfString:@"\n);" withString:@""];
    }] map:^id(NSString *jsonStr) {
        return [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    }] map:^id(NSData *data) {
        NSError *error;
        id o = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSCAssert(!error, @"%@",error);
        return o;
    }];
}

- (RACSignal *)currentTrackForChannelWithId:(id)channelId {
    return [[RadioPlay currentPlaylists] map:^id(NSDictionary *d) {
        NSDictionary *channel = d[channelId];
        NSString *artist = channel[@"artist"];
        BOOL placeholder = [artist isEqualToString:@"Vi er tilbage med mere musik om lidt..."];
        return placeholder ? nil : [Track trackWithArtist:artist title:channel[@"title"]];
    }];
}


@end