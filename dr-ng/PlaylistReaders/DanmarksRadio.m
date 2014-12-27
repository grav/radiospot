//
// Created by Mikkel Gravgaard on 26/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "DanmarksRadio.h"
#import "Track.h"

@implementation DanmarksRadio {
    
}

- (NSString *)filterOutBlacklistedNames:(NSString *)name {
    return [@[@"Intet navn", @"Diverse kunstnere"] containsObject:name] ? nil : name;
}

+ (NSString *)urlForChannelId:(NSString *)channelStr {

    return channelStr ? [NSString stringWithFormat:@"http://www.dr.dk/info/musik/service/TrackInfoJsonService.svc/TrackInfo/%@",
                                                     channelStr] : nil;
}

- (RACSignal *)currentTrackForChannelWithId:(id)channelId {
    NSURL *url = [NSURL URLWithString:[DanmarksRadio urlForChannelId:channelId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return [[NSURLConnection rac_sendAsynchronousRequest:request] map:^id(RACTuple *tuple) {
        RACTupleUnpack(__unused NSURLResponse *_, NSData *data) = tuple;
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
        NSCAssert(!error, @"%@",error);

        NSArray *tracks = (NSArray *) json[@"tracks"];
        NSDictionary *track = [tracks respondsToSelector:@selector(firstObject)] ? tracks.firstObject : nil;
        // filter out 'meta' artist names
        __block NSString *artist;

        [@[@"artist", @"displayArtist"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *artistName = [self filterOutBlacklistedNames:track[obj]];
            *stop = artistName != nil;
            artist = artistName ?: @"";
        }];

        return track ? [Track trackWithArtist:artist title:track[@"title"]] : nil;
    }];
}



@end