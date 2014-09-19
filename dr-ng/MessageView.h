//
// Created by Mikkel Gravgaard on 18/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageView : UIControl
@property (nonatomic, copy) NSString *text;

- (void)show;

- (void)hide;

- (void)showTextBriefly:(NSString *)text;
@end