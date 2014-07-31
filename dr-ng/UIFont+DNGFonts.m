//
// Created by Mikkel Gravgaard on 31/07/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "UIFont+DNGFonts.h"


@implementation UIFont (DNGFonts)
+ (instancetype)channelName {
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f];
}

+ (instancetype)nowPlaying {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:13.0f];
}
@end