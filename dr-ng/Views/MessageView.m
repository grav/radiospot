//
// Created by Mikkel Gravgaard on 18/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MessageView.h"
#import "UIFont+DNGFonts.h"

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
    label.font = [UIFont messageFont];
    [self addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label.superview);
        make.centerY.equalTo(label.superview);
    }];

    RAC(label,text) = RACObserve(self,text);

    return self;
}

- (void)show
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    }];

}

- (void)hide
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    }];
}

- (void)showTextBriefly:(NSString*)text
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.text = text;
    [self show];
    [self performSelector:@selector(hide)
               withObject:nil
               afterDelay:3];
}


@end
