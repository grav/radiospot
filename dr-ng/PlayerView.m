//
// Created by Mikkel Gravgaard on 04/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlayerView.h"
#import "UIFont+DNGFonts.h"
#import "Playlist.h"


@interface PlayerView ()
@property (nonatomic, readwrite) UIButton *addToSpotBtn;
@end

@implementation PlayerView {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    self.backgroundColor = [UIColor blackColor];
    UILabel *label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont songTitle];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.superview).offset(10);
        make.left.equalTo(label.superview).offset(10);
        make.right.equalTo(label.superview).offset(-10);
    }];

    RAC(label,text) = [[RACObserve(self, track) map:^id(NSDictionary *track) {
        return track ? [NSString stringWithFormat:@"%@ - %@", track[kArtist], track[kTitle]] : @" ";
    }] doNext:^(NSString *s) {
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
//                 MPMediaItemPropertyTitle : s
//        }];
    }];



    self.addToSpotBtn = [UIButton new];
    self.addToSpotBtn.titleLabel.font = [UIFont buttonFont];
    [self.addToSpotBtn setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [self.addToSpotBtn setTitle:@"Add to Spotify" forState:UIControlStateNormal];
    [self.addToSpotBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [self.addToSpotBtn setTitleColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.addToSpotBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];

    [self addSubview:self.addToSpotBtn];
    [self.addToSpotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.bottom.equalTo(self.addToSpotBtn.superview).offset(-10);
        make.left.equalTo(self.addToSpotBtn.superview).offset(40);
        make.right.equalTo(self.addToSpotBtn.superview).offset(-40);
    }];

    return self;
}


@end