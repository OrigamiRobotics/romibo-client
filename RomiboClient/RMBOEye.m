//
//  RMBOEye.m
//  RomiboClient
//
//  Created by Doug Suriano on 12/9/13.
//  Copyright (c) 2013 com.romibo. All rights reserved.
//

#import "RMBOEye.h"

@implementation RMBOEye

#define kRMBO_EYEBALL_MIN_X 19.931507
#define kRMBO_EYEBALL_MAX_X 83.424660
#define kRMBO_EYEBALL_MIN_Y 32.054794
#define kRMBO_EYEBALL_MAX_Y 69.863014
#define kRMBO_LEFT_ADJUSTMENT 0.15

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _eyeContainer = [[UIView alloc] initWithFrame:frame];
        [_eyeContainer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"eye"]]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _eyeContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [_eyeContainer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"eye"]]];
        [self addSubview:_eyeContainer];
        
        _eyeball = [[UIImageView alloc] initWithFrame:CGRectMake(75, 75, 48, 48)];
        [_eyeball setImage:[UIImage imageNamed:@"eyeball"]];
        [self addSubview:_eyeball];
    }
    return self;
}

- (void)moveEyeballToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated
{
    xValue = xValue - 0.225;
    
    _eyeballXPosition = (xValue * (kRMBO_EYEBALL_MAX_X - kRMBO_EYEBALL_MIN_X)) + kRMBO_EYEBALL_MIN_X;
    _eyeballYPosition = (yValue * (kRMBO_EYEBALL_MAX_Y - kRMBO_EYEBALL_MIN_Y)) + kRMBO_EYEBALL_MIN_Y;
    
    _eyeballXPosition = (_eyeballXPosition < kRMBO_EYEBALL_MIN_X) ? kRMBO_EYEBALL_MIN_X : _eyeballXPosition;
    _eyeballXPosition = (_eyeballXPosition > kRMBO_EYEBALL_MAX_X) ? kRMBO_EYEBALL_MAX_X : _eyeballXPosition;
    
    _eyeballYPosition = (_eyeballYPosition < kRMBO_EYEBALL_MIN_Y) ? kRMBO_EYEBALL_MIN_Y : _eyeballYPosition;
    _eyeballYPosition = (_eyeballYPosition > kRMBO_EYEBALL_MAX_Y) ? kRMBO_EYEBALL_MAX_Y : _eyeballYPosition;
    
    CGRect currentEyeballRect = [_eyeball frame];
    currentEyeballRect.origin.x = _eyeballXPosition;
    currentEyeballRect.origin.y = _eyeballYPosition;
    
    NSTimeInterval animationRate = 0.2;
    
    if (animated) {
        [UIView animateWithDuration:animationRate animations:^{
            _eyeball.frame = currentEyeballRect;
        }];
    }
    else {
        _eyeball.frame = currentEyeballRect;
    }
}

                    



@end
