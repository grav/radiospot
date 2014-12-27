//
// Created by Mikkel Gravgaard on 25/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "ChannelCell.h"
#import "PlayerViewController.h"
#import "UIFont+DNGFonts.h"
#import "PlayerViewModel.h"
#import "Channel.h"

@implementation ChannelCell {

}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseId];
    if (self) {

        RACSignal *isPlaying = [[self rac_signalForSelector:@selector(setSelected:animated:)] map:^id(RACTuple *tuple) {
                return tuple.first;
            }];

        RAC(self.imageView,image) = [isPlaying map:^id(NSNumber *number) {
            return number.boolValue ? [UIImage imageNamed:@"Images/station_icon_generic_selected"] : [UIImage imageNamed:@"Images/station_icon_generic"];
        }];

        self.textLabel.font = [UIFont channelName];
        RAC(self.textLabel,textColor) = [isPlaying map:^id(NSNumber *number) {
            return number.boolValue ? [UIColor whiteColor] : [UIColor colorWithWhite:0.17 alpha:1];
        }];


        self.detailTextLabel.font = [UIFont nowPlaying];
        RAC(self.detailTextLabel,textColor) = [isPlaying map:^id(NSNumber *number) {
            UIColor *green = [UIColor colorWithRed:0.81
                                             green:0.96
                                              blue:0.67
                                             alpha:1];
            return number.boolValue ? green:[UIColor colorWithWhite:0.51 alpha:1];
        }];

        RAC(self.detailTextLabel,text) = [isPlaying map:^id(NSNumber *number) {
            return number.boolValue ? NSLocalizedString(@"NowPlayingSubtitle", @"Now playing ...") : @" ";
        }];

        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage new]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/cell_bg_selected"]];
        if([self respondsToSelector:@selector(setSeparatorInset:)]){
            self.separatorInset = UIEdgeInsetsZero;
        }
    }

    return self;
}

- (void)configure:(Channel *)channel {
    self.textLabel.text = channel.name;
}

@end