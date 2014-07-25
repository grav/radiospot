//
// Created by Mikkel Gravgaard on 26/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>
#import "PlaylistReader.h"
#import "JSONKit.h"

static const double kPollInterval = 10.0;

@interface PlaylistReader ()
@property(nonatomic, copy, readwrite) NSDictionary *currentTrack;
@end

@implementation PlaylistReader {
    
}

@synthesize channel = _channel;

// Weird junk that came from the service at one point
- (NSArray *)junkTracks {
    return @[
            @{ // p6 junk
                    kTitle : @"The Light (Plane To Spain)",
                    kArtist : @"The William Blakes"}, @{  // p8 junk
                    kTitle : @"Magnetic",
                    kArtist : @"Terence Blanchard"
            }, 
            @{   //p2 junk
                    kTitle : @"Allegro vivace",
                    kArtist : @"Iván Fischer"
            }, 
            @{ // p3 junk
                    kTitle : @"Burhan g",
                    kArtist : @"Burhan G"
            }, 
            @{  // p7 junk
                    kTitle : @"Hung up",
                    kArtist : @"Madonna"
            }];    
}

- (NSString *)filterOutBlacklistedNames:(NSString *)name {
    return [@[@"Intet navn", @"Diverse kunstnere"] containsObject:name] ? nil : name;
}

- (id)init {
    self = [super init];
    if (self) {
        self.channel = ChannelNoChannel;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        RACSignal *periodicSignal = [[RACSignal interval:kPollInterval
                                             onScheduler:[RACScheduler currentScheduler]] startWith:[NSDate date]];

        RACSignal *channelS = [[RACSignal combineLatest:@[periodicSignal, RACObserve(self, channel)]]
                filter:^BOOL(RACTuple *tuple){
                    NSNumber *channelNumber = tuple.second;
                    return ChannelNoChannel != channelNumber.integerValue;
                }];
        RAC(self, currentTrack) = [[channelS

                flattenMap:^RACStream *(RACTuple *aTuple) {
                    NSNumber *channelNumber = aTuple.second;
                    Channel channel = (Channel) channelNumber.integerValue;
                    NSString *urlString = [PlaylistReader urlForChannel:channel];
                    if(!urlString) return [RACSignal return:nil];
                    RACSignal *serviceResponse = [[manager rac_GET:urlString parameters:nil] map:^id(RACTuple *tuple) {
                        AFHTTPRequestOperation *operation = tuple.first;
                        return [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
                    }];
                    return [[serviceResponse map:^id(NSString *htmlString) {
                        NSDictionary *json = [htmlString objectFromJSONString];

                        NSDictionary *track = ((NSArray *) json[@"tracks"]).firstObject;
                        // filter out 'meta' artist names
                        __block NSString *artist;

                        [@[@"artist", @"displayArtist"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            NSString *artistName = [self filterOutBlacklistedNames:track[obj]];
                            *stop = artistName != nil;
                            artist = artistName ?: @"";
                        }];

                        return track ? @{
                                kTitle : track[@"title"],
                                kArtist : artist
                        } : nil;

                    }]  catchTo:[RACSignal empty]];
                }] distinctUntilChanged];
    }
    return self;
}


+ (NSString *)urlForChannel:(Channel)channel {
    NSDictionary *channelStrs = @{
            @(ChannelP1) : @"P1",
            @(ChannelP2) : @"P2",
            @(ChannelP3) : @"P3",
            @(ChannelP5) : @"P5",
            @(ChannelP6Beat) : @"P6B",
            @(ChannelP7Mix) : @"P7M",
            @(ChannelP8Jazz) : @"P8J",

    };
    NSString *channelStr = channelStrs[@(channel)];

    return channelStr ? [NSString stringWithFormat:@"http://www.dr.dk/info/musik/service/TrackInfoJsonService.svc/TrackInfo/%@",
                                                     channelStr] : nil;
}

@end