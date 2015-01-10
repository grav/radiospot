//
// Created by Mikkel Gravgaard on 18/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SpotifyState){
    SpotifyStateNormal,
    SpotifyStateWorking
};

typedef NS_ENUM(NSInteger,ButtonStatus){
    ButtonStatusSuccess,
    ButtonStatusFail,
    ButtonStatusNotFound
};


@interface SpotifyButton : UIControl
@property (nonatomic) BOOL working;


- (void)showStatus:(ButtonStatus)status;
@end