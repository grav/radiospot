//
// Created by Mikkel Gravgaard on 04/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlayerView.h"
#import "UIFont+DNGFonts.h"
#import "Playlist.h"
#import "MessageView.h"
#import "RACStream+BTFAdditions.h"
#import "SpotifyButton.h"
#import "SpotifyButton.h"


@interface PlayerView ()
@property (nonatomic, strong) SpotifyButton *addToSpotBtn;
@property(nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation PlayerView {

}

static UIImage *BgImage;

+ (void)load {
    BgImage = [UIImage imageNamed:@"Images/player_bg"];
}

- (instancetype)init {
    if (!(self = [super initWithFrame:(CGRect){0,0,BgImage.size}])) return nil;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:BgImage];
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UILabel *songTitleLabel = [UILabel new];
    songTitleLabel.textColor = [UIColor whiteColor];
    songTitleLabel.font = [UIFont songTitle];
    [self addSubview:songTitleLabel];
    [songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(songTitleLabel.superview).offset(10);
        make.left.equalTo(songTitleLabel.superview).offset(10);
    }];

    UILabel *artistLabel = [UILabel new];
    artistLabel.textColor = [UIColor colorWithWhite:0.65 alpha:1];
    artistLabel.font = [UIFont artist];
    [self addSubview:artistLabel];
    [artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(songTitleLabel);
        make.top.equalTo(songTitleLabel.mas_bottom);
    }];

    RACSignal *trackSignal = RACObserve(self, track);
    RAC(songTitleLabel,text) = [trackSignal map:^id(NSDictionary *track) {
        return track ? track[kTitle] : @"(Unknown)";
    }];

    RAC(artistLabel,text) = [trackSignal map:^id(NSDictionary *track) {
        return track ? track[kArtist] : @"(Unknown)";
    }];


    self.stopBtn = [UIButton new];
    [self.stopBtn setImage:[UIImage imageNamed:@"Images/stop_btn"] forState:UIControlStateNormal];
    [self addSubview:self.stopBtn];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stopBtn.superview);
        make.right.equalTo(self.stopBtn.superview).offset(-10);
    }];
    // make hit area bigger
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    self.stopBtn.imageEdgeInsets = imageInsets;

    self.addToSpotBtn = [SpotifyButton new];
    [self addSubview:self.addToSpotBtn];
    [self.addToSpotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addToSpotBtn.superview);
        make.right.equalTo(self.stopBtn.mas_left).offset(-5);
    }];
//    self.addToSpotBtn.imageEdgeInsets = imageInsets;

    self.activityIndicatorView = [UIActivityIndicatorView new];
    [self addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.addToSpotBtn);
    }];
    [self.activityIndicatorView startAnimating];

    return self;
}

@end