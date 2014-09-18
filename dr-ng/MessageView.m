//
// Created by Mikkel Gravgaard on 18/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MessageView.h"
#import "UIFont+DNGFonts.h"
#import "RACEXTScope.h"

@implementation MessageView {

}

static UIImage *Image;

+ (void)load {
    Image = [UIImage imageNamed:@"Images/message"];
}

- (instancetype)init {
    if (!(self = [super init])) return nil;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:Image];

    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UILabel *label = [UILabel new];
    label.text = @"Add to Spotify";
    label.font = [UIFont messageFont];
    [self addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label.superview);
        make.centerY.equalTo(label.superview).offset(-5);
    }];

    @weakify(self)
    [[self rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        @strongify(self)
        self.alpha = 0;
    }];

    return self;
}

- (void)setAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.4 animations:^{
        [super setAlpha:alpha];
    }];
}


@end