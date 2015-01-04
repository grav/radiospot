//
// Created by Mikkel Gravgaard on 25/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "ChannelCell.h"
#import "UIFont+DNGFonts.h"
#import "Channel.h"

@implementation ChannelCell {

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {

        RACSignal *highlight = [[[[self rac_signalForSelector:@selector(setSelected:animated:)] map:^id(RACTuple *tuple) {
            return tuple.first;
        }] combineLatestWith:[self rac_signalForSelector:@selector(setHighlighted:animated:)]] map:^id(RACTuple *tuple) {
            RACTupleUnpack(NSNumber *selected, RACTuple *highlightedT) = tuple;
            NSNumber *highlighted = highlightedT.first;
            return @(selected.boolValue || highlighted.boolValue);
        }];

        RAC(self.imageView,image) = [highlight map:^id(NSNumber *number) {
            return number.boolValue ? [UIImage imageNamed:@"Images/station_icon_generic_selected"] : [UIImage imageNamed:@"Images/station_icon_generic"];
        }];

        self.textLabel.font = [UIFont channelName];
        RAC(self.textLabel,textColor) = [highlight map:^id(NSNumber *number) {
            return number.boolValue ? [UIColor whiteColor] : [UIColor colorWithWhite:0.17 alpha:1];
        }];


        self.detailTextLabel.font = [UIFont nowPlaying];
        RAC(self.detailTextLabel,textColor) = [highlight map:^id(NSNumber *number) {
            UIColor *green = [UIColor colorWithRed:0.81
                                             green:0.96
                                              blue:0.67
                                             alpha:1];
            return number.boolValue ? green : [UIColor colorWithWhite:0.51 alpha:1];
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
    self.detailTextLabel.text = channel.broadcaster;
}

@end