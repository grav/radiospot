//
// Created by Mikkel Gravgaard on 25/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "ChannelCell.h"
#import "PlayerViewController.h"

@implementation ChannelCell {

}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseId];
    if (self) {
    }

    return self;
}


- (void)configure:(NSDictionary *)channel {
    self.textLabel.text = channel[kName];
//    self.imageView.image = [UIImage imageWithContentsOfFile:channel.iconLocalURL.absoluteString];
}

@end