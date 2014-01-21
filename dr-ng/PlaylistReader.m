//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlaylistReader.h"
#import "ReactiveCocoa.h"
#import "AFHTTPRequestOperationManager+RACSupport.h"
#import "NSDate+MTDates.h"
#import "HTMLReader.h"

static NSString *const kURL = @"http://www.dr.dk/playlister/%@/%@";
static NSString *const kTime = @".track time";
static NSString *const kTrackName = @".track .trackInfo a";
static NSString *const kArtist = @".track .name";

@implementation PlaylistReader {

}
+ (RACSignal *)trackSignalForChannel:(NSString *)channel {


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return [[[RACSignal interval:5 onScheduler:[RACScheduler currentScheduler]] flattenMap:^RACStream *(NSDate *date) {
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",date.mt_year,date.mt_monthOfYear,date.mt_dayOfMonth];
        NSString *urlString = [NSString stringWithFormat:kURL, channel, dateStr];
        return [[[manager rac_GET:urlString parameters:nil] map:^id(RACTuple *tuple) {
            RACTupleUnpack(AFHTTPRequestOperation *operation, NSDictionary *response) = tuple;
            return [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        }] map:^id(NSString *htmlString) {
            HTMLDocument *document = [HTMLDocument documentWithString:htmlString];

            RACSequence *sequences = [@[kTrackName, kArtist, kTime].rac_sequence map:^id(NSString *selector) {
                return [[document nodesMatchingSelector:selector].rac_sequence map:^id(HTMLNode *node) {
                    return node.innerHTML;
                }];
            }];

            return [RACSequence zip:sequences reduce:^id(NSString *trackName, NSString *artist, NSString *time) {
                return @[trackName, artist, time];
            }].array;
        }];
    }] distinctUntilChanged];
}


@end