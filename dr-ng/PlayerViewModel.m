//
// Created by Mikkel Gravgaard on 15/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlayerViewModel.h"
#import "Channel.h"
#import "NSArray+Functional.h"


static NSString *const kTracksAdded = @"TracksAdded";

static NSString *const kAddUsingRemote = @"didAddUsingRemote";

static NSString *const kChannels = @"channels";

@interface PlayerViewModel ()
@property (nonatomic, strong) NSArray *channels;
@end

@implementation PlayerViewModel {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    _tracksAdded = [[NSUserDefaults standardUserDefaults] integerForKey:kTracksAdded];
    _didAddUsingRemove = [[NSUserDefaults standardUserDefaults] boolForKey:kAddUsingRemote];
    NSData *channelsData = [[NSUserDefaults standardUserDefaults] dataForKey:kChannels];
    if(channelsData){
        NSLog(@"Restoring persisted channel order");
        _channels = [NSKeyedUnarchiver unarchiveObjectWithData:channelsData];
    }
    return self;
}


- (void)setTracksAdded:(int)tracksAdded {
    _tracksAdded = tracksAdded;
    [[NSUserDefaults standardUserDefaults] setInteger:tracksAdded forKey:kTracksAdded];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDidAddUsingRemove:(BOOL)didAddUsingRemote {
    _didAddUsingRemove = didAddUsingRemote;
    [[NSUserDefaults standardUserDefaults] setBool:didAddUsingRemote forKey:kAddUsingRemote];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSArray *)channels {
    if (!_channels) {
        NSArray *dr = [@[
                RACTuplePack(@"P1", @"P1", @"http://drradio1-lh.akamaihd.net/i/p1_9@143503/master.m3u8"),
                RACTuplePack(@"P2", @"P2", @"http://drradio2-lh.akamaihd.net/i/p2_9@143504/master.m3u8"),
                RACTuplePack(@"P3", @"P3", @"http://drradio3-lh.akamaihd.net/i/p3_9@143506/master.m3u8"),
                RACTuplePack(@"P5", @"P5D", @"http://drradio1-lh.akamaihd.net/i/p5_9@143530/master.m3u8"),
                RACTuplePack(@"P6 Beat", @"P6B", @"http://drradio3-lh.akamaihd.net/i/p6beat_9@143533/master.m3u8"),
                RACTuplePack(@"P7 Mix", @"P7M", @"http://drradio1-lh.akamaihd.net/i/p7mix_9@143522/master.m3u8"),
                RACTuplePack(@"P8 Jazz", @"P8J", @"http://drradio2-lh.akamaihd.net/i/p8jazz_9@143524/master.m3u8"),
                RACTuplePack(@"DR MAMA", @"DRM", @"http://drradio3-lh.akamaihd.net/i/drmama_9@143520/master.m3u8"),
                RACTuplePack(@"DR Ramasjang/Ultra Radio", @"Ram", @"http://drradio3-lh.akamaihd.net/i/ramasjang_9@143529/master.m3u8"),
                RACTuplePack(@"DR Nyheder", nil, @"http://drradio2-lh.akamaihd.net/i/drnyheder_9@143532/master.m3u8")] mapUsingBlock:^id(RACTuple *tuple) {
            RACTupleUnpack(NSString *name, NSString *cId, NSString *url) = tuple;
            return [Channel channelWithName:name channelId:cId readerType:PlaylistReaderTypeDR urlString:url broadcaster:@"DR"];
        }];
        
        

        NSArray *sbs = [@[

                RACTuplePack(@"NOVA", @"18", @"http://stream.novafm.dk/nova128?ua=WEB"),
                RACTuplePack(@"The Voice", @"17", @"http://stream.voice.dk/voice128?ua=WEB"),
                RACTuplePack(@"Radio 100", @"20", @"http://onair.100fmlive.dk/100fm_live.mp3?ua=WEB"),
                RACTuplePack(@"Pop FM", @"19", @"http://stream.popfm.dk/pop128?ua=WEB"),
                RACTuplePack(@"myROCK", @"56", @"http://stream.popfm.dk/pop128?ua=WEB"),
                RACTuplePack(@"Radio Soft", @"21", @"http://onair.100fmlive.dk/soft_live.mp3?ua=WEB"),
                RACTuplePack(@"Radio Klassisk", @"22", @"http://onair.100fmlive.dk/klassisk_live.mp3?ua=WEB")

        ] mapUsingBlock:^id(RACTuple *tuple) {
            RACTupleUnpack(NSString *name, NSString *cId, NSString *url) = tuple;
            return [Channel channelWithName:name channelId:cId readerType:PlaylistReaderTypeRadioPlay urlString:url broadcaster:@"SBS"];
        }];
        // Other

        Channel *radio247 = [Channel channelWithName:@"Radio24syv" channelId:nil readerType:PlaylistReaderTypeDummy urlString:@"http://streaming.radio24syv.dk/pls/24syv_64_IR.pls" broadcaster:@"Radio24syv"];

        _channels = [[dr arrayByAddingObjectsFromArray:sbs] arrayByAddingObject:radio247];
    }
    return _channels;
}

- (void)moveChannelFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    NSMutableArray *a = [self.channels mutableCopy];
    [a exchangeObjectAtIndex:from withObjectAtIndex:to];
    self.channels = a;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.channels];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kChannels];
}

@end