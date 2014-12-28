//
// Created by Mikkel Gravgaard on 25/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Channel;


static NSString *const ReuseId = @"ReuseID";

@interface ChannelCell : UITableViewCell
- (void)configure:(Channel*)channel;

@end