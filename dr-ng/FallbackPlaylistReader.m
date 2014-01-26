//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "FallbackPlaylistReader.h"
#import "ReactiveCocoa.h"
#import "AFHTTPRequestOperationManager+RACSupport.h"
#import "NSDate+MTDates.h"
#import "HTMLReader.h"

static NSString *const kURL = @"http://www.dr.dk/playlister/%@/%@";
static NSString *const kCSSTime = @".track time";
static NSString *const kCSSTrackName = @".track .trackInfo a";
static NSString *const kCSSArtist = @".trackInfo .name:nth-of-type(1)";

@interface FallbackPlaylistReader ()
@property (nonatomic, copy, readwrite) NSString *currentTrack;
@end

@implementation FallbackPlaylistReader {
    Channel _channel;
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
            NSString *urlString = [FallbackPlaylistReader urlForChannel:channel date:date];
            return [[[manager rac_GET:urlString parameters:nil] map:^id(RACTuple *tuple) {
                RACTupleUnpack(AFHTTPRequestOperation *operation, NSDictionary *response) = tuple;
                return [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            }] map:^id(NSString *htmlString) {
                HTMLDocument *document = [HTMLDocument documentWithString:htmlString];

                RACSequence *sequences = [@[kCSSTrackName, kCSSArtist, kCSSTime].rac_sequence map:^id(NSString *selector) {
                    return [[document nodesMatchingSelector:selector].rac_sequence map:^id(HTMLNode *node) {
                        return node.innerHTML;
                    }];
                }];

                return [RACSequence zip:sequences reduce:^id(NSString *trackName, NSString *artist, NSString *time) {
                    return [RACTuple tupleWithObjectsFromArray:@[trackName, artist, time]];
                }].array.lastObject;
            }];
        }] distinctUntilChanged];
    }

    return self;
}

- (Channel)channel {
    return _channel;
}


- (void)setChannel:(Channel)channel {
    _channel = channel;

}

+ (NSString *)urlForChannel:(Channel)channel date:(NSDate *)date {

    NSString *channelStr;
    switch (channel){

        case ChannelP2:channelStr=@"p2";break;
        case ChannelP3:channelStr=@"p3";break;
        case ChannelP6Beat:channelStr=@"p6beat";break;
        case ChannelP7Mix:channelStr=@"";break;
        case ChannelP8Jazz:channelStr=@"p8jazz";break;
    }

    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d", date.mt_year, date.mt_monthOfYear, date.mt_dayOfMonth];
    NSString *urlString = [NSString stringWithFormat:kURL, channelStr, dateStr];
    return urlString;
}


@end