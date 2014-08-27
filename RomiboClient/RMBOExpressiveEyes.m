//
//  RMBOExpressiveEye.m
//  RomiboClient
//
//  Created by Doug Suriano on 1/2/14.
//  Copyright (c) 2014 com.romibo. All rights reserved.
//
// This is v2 of the eyes. 

#import "RMBOExpressiveEyes.h"

@interface RMBOExpressiveEyes ()

@property (nonatomic, assign) CGFloat leftEyeballXPosition;
@property (nonatomic, assign) CGFloat leftEyeballYPosition;
@property (nonatomic, assign) CGFloat rightEyeballXPosition;
@property (nonatomic, assign) CGFloat rightEyeballYPosition;

@property (nonatomic, strong) NSArray *leftBlinkAnimationSequence;
@property (nonatomic, strong) NSArray *rightBlinkAnimationSequence;

- (void)placeSubviews;
- (void)setupBlinkingAnimationSequences;

@end
#define kRMBO_LEFT_EYEBALL_MIDDLE_X (142)
#define kRMBO_LEFT_EYEBALL_MIDDLE_Y (108)
#define kRMBO_LEFT_EYEBALL_MIN_X (122)
#define kRMBO_LEFT_EYEBALL_MAX_X (182)

#define kRMBO_RIGHT_EYEBALL_MIDDLE_X (355)
#define kRMBO_RIGHT_EYEBALL_MIDDLE_Y (108)
#define kRMBO_RIGHT_EYEBALL_MIN_X (330)
#define kRMBO_RIGHT_EYEBALL_MAX_X (390)

#define kRMBO_RIGHT_EYE_BACKGROUND_X (317)
#define kRMBO_RIGHT_EYE_BACKGROUND_Y (57.5)

#define kRMBO_LEFT_EYE_BACKGROUND_X (100)
#define kRMBO_LEFT_EYE_BACKGROUND_Y (57.5)

@implementation RMBOExpressiveEyes

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentMood = RMBOEyeMoodHappy;
        [self placeSubviews];
        [self updateEyesForCurrentMood];
        [self setupBlinkingAnimationSequences];
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

- (void)placeSubviews
{
    _leftEyeBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kRMBO_LEFT_EYE_BACKGROUND_X, kRMBO_LEFT_EYE_BACKGROUND_Y, 150, 200)];
    [_leftEyeBackground setContentMode:UIViewContentModeCenter];
    [self addSubview:_leftEyeBackground];
    
    _leftEyeball = [[UIImageView alloc] initWithFrame:CGRectMake(kRMBO_LEFT_EYEBALL_MIDDLE_X, kRMBO_LEFT_EYEBALL_MIDDLE_Y, 72, 109.5)];
    [_leftEyeball setContentMode:UIViewContentModeCenter];
    [self addSubview:_leftEyeball];
    
    _leftEyeLid = [[UIImageView alloc] initWithFrame:CGRectOffset(_leftEyeBackground.frame, 0, 0)];
    [_leftEyeLid setContentMode:UIViewContentModeCenter];
    [self addSubview:_leftEyeLid];
    
    
    _rightEyeBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kRMBO_RIGHT_EYE_BACKGROUND_X, kRMBO_RIGHT_EYE_BACKGROUND_Y, 150, 200)];
    [_rightEyeBackground setContentMode:UIViewContentModeCenter];
    [self addSubview:_rightEyeBackground];
    
    _rightEyeball = [[UIImageView alloc] initWithFrame:CGRectMake(kRMBO_RIGHT_EYEBALL_MIDDLE_X, kRMBO_RIGHT_EYEBALL_MIDDLE_Y, 72, 109.5)];
    [_rightEyeball setContentMode:UIViewContentModeCenter];
    [self addSubview:_rightEyeball];
    
    _rightEyeLid = [[UIImageView alloc] initWithFrame:CGRectOffset(_rightEyeBackground.frame, 0, 0)];
    [_rightEyeLid setContentMode:UIViewContentModeCenter];
    [self addSubview:_rightEyeLid];
}



- (void)setupBlinkingAnimationSequences
{

    _leftBlinkAnimationSequence = @[
                                    [UIImage imageNamed:@"left_reg_closed"],
                                    [UIImage imageNamed:@"left_reg_blink1"],
                                    [UIImage imageNamed:@"left_reg_blink2"],
                                    [UIImage imageNamed:@"left_reg_blink3"]
                                    ];
    
    _rightBlinkAnimationSequence = @[
                                    [UIImage imageNamed:@"right_reg_closed"],
                                    [UIImage imageNamed:@"right_reg_blink1"],
                                    [UIImage imageNamed:@"right_reg_blink2"],
                                    [UIImage imageNamed:@"right_reg_blink3"]
                                    ];
}


- (void)updateEyesForCurrentMood
{
//    if (_currentMood == RMBOEyeMoodRegular) {
    
        [_leftEyeBackground setImage:[UIImage imageNamed:@"left_reg_eyeback"]];
        [_rightEyeBackground setImage:[UIImage imageNamed:@"right_reg_eyeback"]];
        
    [_leftEyeball setImage:[UIImage imageNamed:@"reg_eyeball"]];
    [_rightEyeball setImage:[UIImage imageNamed:@"reg_eyeball"]];
    
}

- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated
{
    
    xValue = xValue - 0.225;
    
    _leftEyeballXPosition = (xValue * (kRMBO_LEFT_EYEBALL_MAX_X - kRMBO_LEFT_EYEBALL_MIN_X)) + kRMBO_LEFT_EYEBALL_MIN_X;
    
    _rightEyeballXPosition = (xValue * (kRMBO_RIGHT_EYEBALL_MAX_X - kRMBO_RIGHT_EYEBALL_MIN_X)) + kRMBO_RIGHT_EYEBALL_MIN_X;

    
    _leftEyeballXPosition = (_leftEyeballXPosition < kRMBO_LEFT_EYEBALL_MIN_X) ? kRMBO_LEFT_EYEBALL_MIN_X : _leftEyeballXPosition;
    _leftEyeballXPosition = (_leftEyeballXPosition > kRMBO_LEFT_EYEBALL_MAX_X) ? kRMBO_LEFT_EYEBALL_MAX_X : _leftEyeballXPosition;
    
    _rightEyeballXPosition = (_rightEyeballXPosition < kRMBO_RIGHT_EYEBALL_MIN_X) ? kRMBO_RIGHT_EYEBALL_MIN_X : _rightEyeballXPosition;
    _rightEyeballXPosition = (_rightEyeballXPosition > kRMBO_RIGHT_EYEBALL_MAX_X) ? kRMBO_RIGHT_EYEBALL_MAX_X : _rightEyeballXPosition;

    CGRect leftEyeballRect = [_leftEyeball frame];
    CGRect rightEyeballRect = [_rightEyeball frame];
    
    leftEyeballRect.origin.x = _leftEyeballXPosition;
    rightEyeballRect.origin.x = _rightEyeballXPosition;
    
    NSTimeInterval animationRate = 0.2;
    
    if (animated) {
        [UIView animateWithDuration:animationRate animations:^{
            _leftEyeball.frame = leftEyeballRect;
            _rightEyeball.frame = rightEyeballRect;
            
        }];
    }
    else {
        _leftEyeball.frame = leftEyeballRect;
        _rightEyeball.frame = rightEyeballRect;
    }
}

- (void)closeEyes
{
    [_blinkTimer invalidate];
    _blinkTimer = nil;
    [_leftEyeLid setImage:[UIImage imageNamed:@"left_reg_closed"]];
    [_rightEyeLid setImage:[UIImage imageNamed:@"right_reg_closed"]];
}

- (void)openEyes
{
    [self moveEyeballsToX:0.5 andY:0.5 animated:NO];
    _blinkTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(blinkEyes) userInfo:nil repeats:YES];
    [_leftEyeLid setImage:nil];
    [_rightEyeLid setImage:nil];
    [self blinkEyes];
}

- (void)blinkEyes
{
    [_leftEyeLid setAnimationImages:_leftBlinkAnimationSequence];
    [_leftEyeLid setAnimationRepeatCount:1];
    [_leftEyeLid setAnimationDuration:0.3];
    
    [_rightEyeLid setAnimationImages:_rightBlinkAnimationSequence];
    [_rightEyeLid setAnimationRepeatCount:1];
    [_rightEyeLid setAnimationDuration:0.3];
    
    [_leftEyeLid startAnimating];
    [_rightEyeLid startAnimating];
}

- (void)changeEyeMood:(RMBOEyeMood)mood
{
    _currentMood = mood;
    
    if (_currentMood == RMBOEyeMoodHappy) {
    }
    else if (_currentMood == RMBOEyeMoodSad) {
    }
    else if (_currentMood == RMBOEyeMoodExcited) {
     }
    else if (_currentMood == RMBOEyeMoodConfused) {
    }
    else if (_currentMood == RMBOEyeBlink) {
        [self closeEyes];
        [self openEyes];
    }
    else {  // Blink
        [self closeEyes];
        [self openEyes];
    }

    
//    [self setupLidSequenceArrayWithMood:_currentMood];
//    [self setupBrowSequenceArrayWithMood:_currentMood];
}

- (void)turnOnAutoBlinkWithTimeInterval:(NSTimeInterval)interval
{
    _blinkTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(blinkEyes) userInfo:nil repeats:YES];
}

- (void)turnOffAutoBlink
{
    [_blinkTimer invalidate];
    _blinkTimer = nil;
}


@end
