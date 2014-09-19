//
// Created by Mikkel Gravgaard on 19/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "UIActivityIndicatorView+BTFAdditions.h"


@implementation UIActivityIndicatorView (BTFAdditions)
- (BOOL)animate{
    return self.isAnimating;
}

- (void)setAnimate:(BOOL)animate{
    if(animate){
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}


@end