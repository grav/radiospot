//
// Created by Mikkel Gravgaard on 04/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpotifyButton;
@class Track;


@interface PlayerView : UIView
@property (nonatomic, readonly) SpotifyButton *addToSpotBtn;
@property(nonatomic, readonly) UIButton *stopBtn;
@property (nonatomic, strong) Track *track;
@end