//
// Created by Mikkel Gravgaard on 18/09/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "OverlayView.h"
#import "MASConstraintMaker+Self.h"
#import "NSArray+Functional.h"
#import "POP.h"
#import "RACEXTScope.h"

@interface OverlayView ()
@property(nonatomic, strong) UIImageView *finger;
@property(nonatomic, strong) NSArray *rings;
@end

@implementation OverlayView {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];

    UIImageView *white = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/overlay_white"]];

    [self addSubview:white];
    [white mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(make.superview);
    }];

    self.rings = [@[@"Images/ring1", @"Images/ring2", @"Images/ring3"] mapUsingBlock:^id(NSString *imageName) {
        return  [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }];
    self.finger = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finger"]];

    [[self.rings arrayByAddingObject:self.finger] enumerateObjectsUsingBlock:^(UIView *v, NSUInteger idx, BOOL *stop) {
        [white addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(make.superview);
            make.centerY.equalTo(make.superview).offset(-23);
        }];
    }];


    UIImageView *closeButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/close"]];
    [white addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(closeButton.superview.mas_right).offset(-4);
        make.centerY.equalTo(closeButton.superview.mas_top).offset(4);
    }];

    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"TripleClickMessage", @"Triple-click your remote\nto add song to Spotify");
    label.font = [UIFont systemFontOfSize:12];
    [white addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(make.superview);
        make.bottom.equalTo(make.superview).offset(-20);
    }];

    [self doOneAnim];

    @weakify(self)
    [[self rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        @strongify(self)
        [self dismiss];
    }];

    return self;



}


- (void)doOneAnim
{
    for(int i=0;i<3;i++){
        [self performSelector:@selector(animateRings) withObject:nil afterDelay:i*0.6+1];
    }

    [self performSelector:@selector(doOneAnim) withObject:nil afterDelay:3];
}

- (void)dismiss {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)animateRings
{
    float springBounciness = 20.f;

    float innerSpringSpeed = 15.0f;
    float midSpringSpeed = 10.f;
    float outterSpringSpeed = 5.f;

    NSArray *speeds = @[@(innerSpringSpeed),@(midSpringSpeed),@(outterSpringSpeed)];

    float fromSizeValue = 1.0f;
    float toSizeValue = 0.95f;


    for(NSUInteger i=0;i< self.rings.count;i++){
        POPSpringAnimation *innerImageAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        innerImageAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(fromSizeValue, fromSizeValue)];
        innerImageAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(toSizeValue, toSizeValue)];
        innerImageAnimation.springBounciness = springBounciness;
        innerImageAnimation.springSpeed = [speeds[i] floatValue];
        NSString *key = [NSString stringWithFormat:@"animationKey%d",i];
        [((UIView*) self.rings[i]).layer pop_addAnimation:innerImageAnimation forKey:key];
    }

    POPSpringAnimation *innerImageAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    innerImageAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(toSizeValue, toSizeValue)];
    innerImageAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(fromSizeValue, fromSizeValue)];
    innerImageAnimation.springBounciness = 10;
    innerImageAnimation.springSpeed = outterSpringSpeed;
    NSString *key = @"fingerKey";
    [self.finger.layer pop_addAnimation:innerImageAnimation forKey:key];

}

@end