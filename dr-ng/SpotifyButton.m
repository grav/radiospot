//
// Created by Mikkel Gravgaard on 18/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "SpotifyButton.h"
#import "MASConstraintMaker+Self.h"
#import "UIActivityIndicatorView+BTFAdditions.h"
@interface SpotifyButton ()
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;
@property(nonatomic, strong) UIImageView *imageView;
@end

static CGFloat kDim = 30.0f;

@implementation SpotifyButton {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(make.superview);
    }];

    self.activityIndicatorView = [UIActivityIndicatorView new];
    self.activityIndicatorView.color = [UIColor colorWithRed:122/255.0f green:170/255.0f
                                                                blue:64/255.0f alpha:1.0f];
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(make.superview);
    }];
    [self.activityIndicatorView startAnimating];

    RAC(self.activityIndicatorView,animate) = [RACObserve(self, enabled) not];

    RAC(self.imageView,image) = [RACObserve(self, enabled) map:^id(NSNumber *number) {
        return number.boolValue ? [UIImage imageNamed:@"Images/spot_btn"] : [UIImage imageNamed:@"Images/empty_btn"];
    }];

    return self;
}

- (void)regular{

//    self.imageView.image = ;
}


- (void)work {
//    self.imageView.image = ;
}

- (void)fail {
    [self regular];
}

- (void)notFound
{
    [self regular];
}

- (void)success{
    [self regular];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kDim, kDim);
}


@end