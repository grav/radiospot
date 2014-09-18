//
// Created by Mikkel Gravgaard on 18/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "RACStream+BTFAdditions.h"


@implementation RACStream (BTFAdditions)
- (instancetype)tupleFirst {
    return [self map:^id(RACTuple *t) {
        return t.first;
    }];
}

- (instancetype)tupleSecond {
    return [self map:^id(RACTuple *t) {
        return t.second;
    }];
}

- (instancetype)tupleThird {
    return [self map:^id(RACTuple *t) {
        return t.third;
    }];
}@end