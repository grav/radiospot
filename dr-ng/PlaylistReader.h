//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
static NSString *const kP6Beat = @"p6beat";
static NSString *const kP3 = @"p3";

@interface PlaylistReader : NSObject

+ (RACSignal *)trackSignalForChannel:(NSString *)channel;

+ (NSString *)urlForChannel:(NSString *)channel date:(NSDate *)date;
@end