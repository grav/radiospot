//
// Created by Mikkel Gravgaard on 12/09/14.
// Copyright (c) 2014 Shape. All rights reserved.
//

#import "MASConstraintMaker+Self.h"


@implementation MASConstraintMaker (Selfie)
- (UIView *)selfie {
    return [self valueForKeyPath:@"view"];
}

- (UIView *)superview {
    return self.selfie.superview;
}

@end