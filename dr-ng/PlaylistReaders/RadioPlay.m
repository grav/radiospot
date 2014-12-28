//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "RadioPlay.h"
#import "Track.h"

static NSString *RadioPlay_PlaylistURL = @"http://static.radioplay.dk/data/all_dk.jsonp";

@implementation RadioPlay {

}

+ (NSString *)testdata
{
    return @"onair_callback(\n"
            "{\"17\":{\"artist\":\"Vi er tilbage med mere musik om lidt...\",\"title\":\"\"},\"18\":{\"itunes_link\":\"http:\\/\\/clk.tradedoubler.com\\/click?p=23762&a=1484948&g=11617567&url=https:\\/\\/itunes.apple.com\\/dk\\/album\\/twerk-it-like-miley-feat.\\/id869414908?i=869414960&uo=4\",\"artist\":\"Brandon Beal\",\"cover_url\":\"http:\\/\\/static.shop2download.com\\/images\\/75\\/58\\/0000000028387558_256x256_large.jpg\",\"title\":\"TWERK IT LIKE MILEY\"},\"19\":{\"itunes_link\":\"http:\\/\\/clk.tradedoubler.com\\/click?p=23762&a=1484948&g=11617567&url=http:\\/\\/itunes.apple.com\\/dk\\/album\\/straight-up\\/id18389736?i=18389638&uo=4\",\"artist\":\"Paula Abdul\",\"cover_url\":\"http:\\/\\/www.radioplay.se\\/img\\/artists\\/2071_square.jpg\",\"title\":\"Straight Up\"},\"20\":{\"itunes_link\":\"http:\\/\\/clk.tradedoubler.com\\/click?p=23762&a=1484948&g=11617567&url=http:\\/\\/itunes.apple.com\\/dk\\/album\\/need-you-now\\/id365962811?i=365962840&uo=4\",\"artist\":\"Lady Antebellum\",\"cover_url\":\"http:\\/\\/www.radioplay.se\\/img\\/artists\\/1983_square.jpg\",\"title\":\"Need You Now\"},\"21\":{\"itunes_link\":\"http:\\/\\/clk.tradedoubler.com\\/click?p=23762&a=1484948&g=11617567&url=https:\\/\\/itunes.apple.com\\/dk\\/album\\/jul-det-cool\\/id572870442?i=572870530&uo=4\",\"artist\":\"MC Einar\",\"cover_url\":\"http:\\/\\/static.shop2download.com\\/images\\/99\\/31\\/0000000007659931_256x256_large.jpg\",\"title\":\"Jul\"},\"22\":{\"itunes_link\":\"http:\\/\\/clk.tradedoubler.com\\/click?p=23762&a=1484948&g=11617567&url=https:\\/\\/itunes.apple.com\\/dk\\/album\\/speak-low\\/id43595415?i=43595334&l=en&uo=4\",\"artist\":\"Kurt Weill\",\"cover_url\":\"http:\\/\\/rovimusic.rovicorp.com\\/image.jpg?c=fQfRQQPbAotUqQS9FWGgUXm4Ir7j3e2oJQ3ax8UrZe8=&f=1\",\"title\":\"SPEAK LOW\"},\"56\":{\"itunes_link\":\"http:\\/\\/clk.tradedoubler.com\\/click?p=23762&a=1484948&g=11617567&url=http:\\/\\/itunes.apple.com\\/dk\\/album\\/under-the-bridge\\/id3625624?i=3625458&uo=4\",\"artist\":\"Red Hot Chili Peppers\",\"cover_url\":\"http:\\/\\/www.radioplay.se\\/img\\/artists\\/62_square.jpg\",\"title\":\"Under The Bridge\"}}\n"
            ");";


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