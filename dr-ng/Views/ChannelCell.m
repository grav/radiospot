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

        self.textLabel.text = @"";
        self.detailTextLabel.text = @"";
        self.textLabel.font = [UIFont channelName];

        self.detailTextLabel.font = [UIFont nowPlaying];

        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage new]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/cell_bg_selected"]];
        if([self respondsToSelector:@selector(setSeparatorInset:)]){
            self.separatorInset = UIEdgeInsetsZero;
        }
    }

    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL highOrSel = self.highlighted || self.selected;
    self.imageView.image = highOrSel ? [UIImage imageNamed:@"Images/station_icon_generic_selected"] : [UIImage imageNamed:@"Images/station_icon_generic"];

    self.textLabel.textColor  = highOrSel ? [UIColor whiteColor] : [UIColor colorWithWhite:0.17 alpha:1];

    self.detailTextLabel.textColor = highOrSel ? [UIColor colorWithRed:0.81
                                                                 green:0.96
                                                                  blue:0.67
                                                                 alpha:1] :
            [UIColor colorWithWhite:0.51 alpha:1];


}

- (void)configure:(Channel *)channel {
    self.textLabel.text = channel.name;
    self.detailTextLabel.text = channel.broadcaster;
    [self setNeedsLayout];
}

@end