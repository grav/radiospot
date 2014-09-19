//
// Created by Mikkel Gravgaard on 04/08/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpotifyButton;


@interface PlayerView : UIView
@property (nonatomic, readonly) SpotifyButton *addToSpotBtn;
@property(nonatomic, readonly) UIButton *stopBtn;
@property (nonatomic, strong) NSDictionary *track;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;
@end