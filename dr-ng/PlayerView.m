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
        return track ? track[kTitle] : @" ";
    }];

    RAC(artistLabel,text) = [trackSignal map:^id(NSDictionary *track) {
        return track ? track[kArtist] : @" ";
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
        make.centerY.equalTo(self.addToSpotBtn.superview);
        make.right.equalTo(self.addToSpotBtn.superview).offset(-10);
    }];

    return self;
}

@end