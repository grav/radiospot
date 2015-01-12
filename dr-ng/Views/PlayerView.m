//
// Created by Mikkel Gravgaard on 04/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "PlayerView.h"
#import "UIFont+DNGFonts.h"
#import "SpotifyButton.h"
#import "Track.h"


@interface PlayerView ()
@property (nonatomic, strong) SpotifyButton *addToSpotBtn;
@property(nonatomic, strong) UIButton *stopBtn;
@property(nonatomic, strong) UILabel *songTitleLabel;
@property(nonatomic, strong) UILabel *artistLabel;
@end

@implementation PlayerView {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;

    self.backgroundColor = [UIColor colorWithWhite:0.17 alpha:1];

    self.songTitleLabel = [UILabel new];
    self.songTitleLabel.textColor = [UIColor whiteColor];
    self.songTitleLabel.font = [UIFont songTitle];
    self.songTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.songTitleLabel];


    self.artistLabel = [UILabel new];
    self.artistLabel.textColor = [UIColor colorWithWhite:0.65 alpha:1];
    self.artistLabel.font = [UIFont artist];
    self.artistLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.artistLabel];

    RACSignal *trackSignal = RACObserve(self, track);
    RAC(self.songTitleLabel,text) = [trackSignal map:^id(Track *track) {
        return track ? track.title : NSLocalizedString(@"SongTitleUnknown", @"(Unknown)");
    }];

    RAC(self.artistLabel,text) = [trackSignal map:^id(Track *track) {
        return track ? track.artist : NSLocalizedString(@"ArtistUnknown", @"(Unknown)");
    }];



    self.stopBtn = [UIButton new];
    [self.stopBtn setImage:[UIImage imageNamed:@"Images/stop_btn"] forState:UIControlStateNormal];
    [self addSubview:self.stopBtn];

    // make hit area bigger
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    self.stopBtn.imageEdgeInsets = imageInsets;

    self.addToSpotBtn = [SpotifyButton new];
    [self addSubview:self.addToSpotBtn];



    return self;
}

- (void)updateConstraints {

    [self.songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.songTitleLabel.superview).offset(10);
        make.left.equalTo(self.songTitleLabel.superview).offset(10);
        make.right.equalTo(self.addToSpotBtn.mas_left);
    }];

    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.songTitleLabel);
        make.top.equalTo(self.songTitleLabel.mas_bottom);
        make.right.equalTo(self.addToSpotBtn.mas_left);
    }];

    [self.addToSpotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addToSpotBtn.superview);
        make.right.equalTo(self.stopBtn.mas_left).offset(-4);
        make.width.height.mas_equalTo(40);
    }];

    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stopBtn.superview);
        make.right.equalTo(self.stopBtn.superview).offset(-5);
        make.width.height.mas_equalTo(40);
    }];


    [super updateConstraints];
}


@end