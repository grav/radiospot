//
// Created by Mikkel Gravgaard on 25/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "ChannelCell.h"
#import "PlayerViewController.h"

@implementation ChannelCell {

}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseId];
    if (self) {

        UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [stopButton addTarget:nil action:@selector(stop:)
             forControlEvents:UIControlEventTouchUpInside];

        [stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [stopButton setTitle:@"◼" forState:UIControlStateNormal];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:stopButton];
        [stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(stopButton.superview);
            make.right.equalTo(stopButton.superview).offset(-10);
        }];

        RACSignal *isPlaying = [[self rac_signalForSelector:@selector(setSelected:animated:)] map:^id(RACTuple *tuple) {
                return tuple.first;
            }];
        RAC(stopButton,hidden) = [isPlaying not];

        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage new]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/cell_bg_selected"]];
        self.separatorInset = UIEdgeInsetsZero;
    }

    return self;
}


- (void)configure:(NSDictionary *)channel {
    self.textLabel.text = channel[kName];
//    self.imageView.image = [UIImage imageWithContentsOfFile:channel.iconLocalURL.absoluteString];
}

@end