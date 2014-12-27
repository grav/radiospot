//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaylistReader.h"


@interface RadioPlay : NSObject <PlaylistReader>


+ (RACSignal *)currentPlaylists;
@end