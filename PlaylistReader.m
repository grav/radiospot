//
// Created by Mikkel Gravgaard on 26/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>
#import "PlaylistReader.h"
#import "AFNetworking.h"
#import "JSONKit.h"

@interface PlaylistReader ()
@property (nonatomic, copy, readwrite) NSString *currentTrack;
@end

@implementation PlaylistReader {

}


- (id)init {
    self = [super init];
    if (self) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        RACSignal *periodicSignal = [RACSignal interval:5 onScheduler:[RACScheduler currentScheduler]];

        RAC(self,currentTrack) = [[[RACSignal combineLatest:@[periodicSignal, RACObserve(self, channel)]] flattenMap:^RACStream *(RACTuple *aTuple) {
            RACTupleUnpack(NSDate *date,NSNumber *channelNumber) = aTuple;
            Channel channel = (Channel) channelNumber.integerValue;
            NSString *urlString = [PlaylistReader urlForChannel:channel];
            return [[[manager rac_GET:urlString parameters:nil] map:^id(RACTuple *tuple) {
                RACTupleUnpack(AFHTTPRequestOperation *operation, NSDictionary *response) = tuple;
                return [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            }] map:^id(NSString *htmlString) {
                NSDictionary *json = [htmlString objectFromJSONString];

                NSDictionary *track = ((NSArray *)json[@"tracks"]).firstObject;
                return @{kTitle:track[@"title"], kArtist:track[@"artist"]};

            }];
        }] distinctUntilChanged];
    }
    return self;
}


- (Channel)channel {
    return ChannelP3;
}

- (void)setChannel:(Channel)channel {

}

+ (NSString *)urlForChannel:(Channel)channel {

    NSString *channelStr;
    switch (channel){

        case ChannelP2:channelStr=@"P2";break;
        case ChannelP3:channelStr=@"P3";break;
        case ChannelP6Beat:channelStr=@"P6B";break;
        case ChannelP7Mix:channelStr=@"P7M";break;
        case ChannelP8Jazz:channelStr=@"P8J";break;
    }

    NSString *urlString = [NSString stringWithFormat:@"http://www.dr.dk/info/musik/service/TrackInfoJsonService.svc/TrackInfo/%@", channelStr];
    return urlString;
}

@end