//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Track : NSObject
@property (nonatomic, copy, readonly) NSString *artist, *title;

+ (id)trackWithArtist:(NSString *)artist title:(id)title;
@end