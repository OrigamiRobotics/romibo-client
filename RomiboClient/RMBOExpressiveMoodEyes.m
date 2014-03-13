//
//  RMBOExpressiveMoodEyes.m
//  RomiboClient
//
//  Created by Doug Suriano on 2/19/14.
//  Copyright (c) 2014 com.romibo. All rights reserved.
//
// These are the eyes in uses

#import "RMBOExpressiveMoodEyes.h"

@interface RMBOExpressiveMoodEyes ()


@property (nonatomic, strong) UIImageView *whites;
@property (nonatomic, strong) UIImageView *pupils;
@property (nonatomic, strong) UIImageView *lids;
@property (nonatomic, strong) UIImageView *brows;

@property (nonatomic, strong) NSArray *lidSequenceOpenSequence;
@property (nonatomic, strong) NSArray *lidSequenceCloseSequence;

@property (nonatomic, strong) NSArray *browSequenceOpenSequence;
@property (nonatomic, strong) NSArray *browSequenceCloseSequence;

@property (nonatomic, assign) RMBOEyeMood currentMood;

@property (nonatomic, strong) NSTimer *blinkTimer;

- (void)placeSubviews;

- (void)setupLidSequenceArrayWithMood:(RMBOEyeMood)mood;
- (void)setupBrowSequenceArrayWithMood:(RMBOEyeMood)mood;
@end


@implementation RMBOExpressiveMoodEyes

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self placeSubviews];
        [self changeEyeMood:RMBOEyeMoodSad];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self placeSubviews];
        [self changeEyeMood:RMBOEyeMoodHappy];
    }
    return self;
}

- (void)changeEyeMood:(RMBOEyeMood)mood
{
    [self closeEyes];
    _currentMood = mood;
    
    if (_currentMood == RMBOEyeMoodHappy) {
        [_whites setImage:[UIImage imageNamed:@"happy_whites"]];
        [_pupils setImage:[UIImage imageNamed:@"happy_pupils"]];
    }
    else if (_currentMood == RMBOEyeMoodSad) {
        [_whites setImage:[UIImage imageNamed:@"sad_whites"]];
        [_pupils setImage:[UIImage imageNamed:@"sad_pupils"]];
    }
    else if (_currentMood == RMBOEyeMoodExcited) {
        [_whites setImage:[UIImage imageNamed:@"excited_whites"]];
        [_pupils setImage:[UIImage imageNamed:@"excited_pupils"]];
    }
    else if (_currentMood == RMBOEyeMoodConfused) {
        [_whites setImage:[UIImage imageNamed:@"confused_whites"]];
        [_pupils setImage:[UIImage imageNamed:@"confused_pupils"]];
    }
    
    [self setupLidSequenceArrayWithMood:_currentMood];
    [self setupBrowSequenceArrayWithMood:_currentMood];
    [self openEyes];
}

- (void)setupLidSequenceArrayWithMood:(RMBOEyeMood)mood
{
    if (mood == RMBOEyeMoodHappy) {
        _lidSequenceOpenSequence = @[[UIImage imageNamed:@"happy_lids_00000.png"],
                                     [UIImage imageNamed:@"happy_lids_00001.png"],
                                     [UIImage imageNamed:@"happy_lids_00002.png"],
                                     [UIImage imageNamed:@"happy_lids_00003.png"],
                                     [UIImage imageNamed:@"happy_lids_00004.png"],
                                     [UIImage imageNamed:@"happy_lids_00005.png"],
                                     [UIImage imageNamed:@"happy_lids_00006.png"]
                                     ];
        
        _lidSequenceCloseSequence = @[[UIImage imageNamed:@"happy_lids_00084.png"],
                                      [UIImage imageNamed:@"happy_lids_00085.png"],
                                      [UIImage imageNamed:@"happy_lids_00086.png"],
                                      [UIImage imageNamed:@"happy_lids_00087.png"],
                                      [UIImage imageNamed:@"happy_lids_00088.png"],
                                      [UIImage imageNamed:@"happy_lids_00089.png"],
                                      [UIImage imageNamed:@"happy_lids_00090.png"]
                                      ];
    }
    else if (mood == RMBOEyeMoodSad) {
        _lidSequenceOpenSequence = @[[UIImage imageNamed:@"sad_lids_00000.png"],
                                     [UIImage imageNamed:@"sad_lids_00001.png"],
                                     [UIImage imageNamed:@"sad_lids_00002.png"],
                                     [UIImage imageNamed:@"sad_lids_00003.png"],
                                     [UIImage imageNamed:@"sad_lids_00004.png"],
                                     [UIImage imageNamed:@"sad_lids_00005.png"],
                                     [UIImage imageNamed:@"sad_lids_00006.png"]
                                     ];
        
        _lidSequenceCloseSequence = @[[UIImage imageNamed:@"sad_lids_00084.png"],
                                      [UIImage imageNamed:@"sad_lids_00085.png"],
                                      [UIImage imageNamed:@"sad_lids_00086.png"],
                                      [UIImage imageNamed:@"sad_lids_00087.png"],
                                      [UIImage imageNamed:@"sad_lids_00088.png"],
                                      [UIImage imageNamed:@"sad_lids_00089.png"],
                                      [UIImage imageNamed:@"sad_lids_00090.png"]
                                      ];
    }
    else if (mood == RMBOEyeMoodExcited) {
        _lidSequenceOpenSequence = @[[UIImage imageNamed:@"excited_lids_00000.png"],
                                     [UIImage imageNamed:@"excited_lids_00001.png"],
                                     [UIImage imageNamed:@"excited_lids_00002.png"],
                                     [UIImage imageNamed:@"excited_lids_00003.png"],
                                     [UIImage imageNamed:@"excited_lids_00004.png"],
                                     [UIImage imageNamed:@"excited_lids_00005.png"],
                                     [UIImage imageNamed:@"excited_lids_00006.png"]
                                     ];
        
        _lidSequenceCloseSequence = @[[UIImage imageNamed:@"excited_lids_00084.png"],
                                      [UIImage imageNamed:@"excited_lids_00085.png"],
                                      [UIImage imageNamed:@"excited_lids_00086.png"],
                                      [UIImage imageNamed:@"excited_lids_00087.png"],
                                      [UIImage imageNamed:@"excited_lids_00088.png"],
                                      [UIImage imageNamed:@"excited_lids_00089.png"],
                                      [UIImage imageNamed:@"excited_lids_00090.png"]
                                      ];
    }
    else {
        _lidSequenceOpenSequence = @[[UIImage imageNamed:@"confused_lids_00000.png"],
                                     [UIImage imageNamed:@"confused_lids_00001.png"],
                                     [UIImage imageNamed:@"confused_lids_00002.png"],
                                     [UIImage imageNamed:@"confused_lids_00003.png"],
                                     [UIImage imageNamed:@"confused_lids_00004.png"],
                                     [UIImage imageNamed:@"confused_lids_00005.png"],
                                     [UIImage imageNamed:@"confused_lids_00006.png"]
                                     ];
        
        _lidSequenceCloseSequence = @[[UIImage imageNamed:@"confused_lids_00084.png"],
                                      [UIImage imageNamed:@"confused_lids_00085.png"],
                                      [UIImage imageNamed:@"confused_lids_00086.png"],
                                      [UIImage imageNamed:@"confused_lids_00087.png"],
                                      [UIImage imageNamed:@"confused_lids_00088.png"],
                                      [UIImage imageNamed:@"confused_lids_00089.png"],
                                      [UIImage imageNamed:@"confused_lids_00090.png"]
                                      ];
    }
}

- (void)setupBrowSequenceArrayWithMood:(RMBOEyeMood)mood
{
    if (mood == RMBOEyeMoodHappy) {
        _browSequenceOpenSequence = @[[UIImage imageNamed:@"happy_brows_00000.png"],
                                     [UIImage imageNamed:@"happy_brows_00001.png"],
                                     [UIImage imageNamed:@"happy_brows_00002.png"],
                                     [UIImage imageNamed:@"happy_brows_00003.png"],
                                     [UIImage imageNamed:@"happy_brows_00004.png"],
                                     [UIImage imageNamed:@"happy_brows_00005.png"],
                                     [UIImage imageNamed:@"happy_brows_00006.png"]
                                     ];
        
        _browSequenceCloseSequence = @[[UIImage imageNamed:@"happy_brows_00084.png"],
                                      [UIImage imageNamed:@"happy_brows_00085.png"],
                                      [UIImage imageNamed:@"happy_brows_00086.png"],
                                      [UIImage imageNamed:@"happy_brows_00087.png"],
                                      [UIImage imageNamed:@"happy_brows_00088.png"],
                                      [UIImage imageNamed:@"happy_brows_00089.png"],
                                      [UIImage imageNamed:@"happy_brows_00090.png"]
                                      ];
    }
    else if (mood == RMBOEyeMoodSad) {
        _browSequenceOpenSequence = @[[UIImage imageNamed:@"sad_brows_00000.png"],
                                      [UIImage imageNamed:@"sad_brows_00001.png"],
                                      [UIImage imageNamed:@"sad_brows_00002.png"],
                                      [UIImage imageNamed:@"sad_brows_00003.png"],
                                      [UIImage imageNamed:@"sad_brows_00004.png"],
                                      [UIImage imageNamed:@"sad_brows_00005.png"],
                                      [UIImage imageNamed:@"sad_brows_00006.png"]
                                      ];
        
        _browSequenceCloseSequence = @[[UIImage imageNamed:@"sad_brows_00084.png"],
                                       [UIImage imageNamed:@"sad_brows_00085.png"],
                                       [UIImage imageNamed:@"sad_brows_00086.png"],
                                       [UIImage imageNamed:@"sad_brows_00087.png"],
                                       [UIImage imageNamed:@"sad_brows_00088.png"],
                                       [UIImage imageNamed:@"sad_brows_00089.png"],
                                       [UIImage imageNamed:@"sad_brows_00090.png"]
                                       ];
    }
    else if (mood == RMBOEyeMoodExcited) {
        _browSequenceOpenSequence = @[[UIImage imageNamed:@"excited_brows_00000.png"],
                                      [UIImage imageNamed:@"excited_brows_00001.png"],
                                      [UIImage imageNamed:@"excited_brows_00002.png"],
                                      [UIImage imageNamed:@"excited_brows_00003.png"],
                                      [UIImage imageNamed:@"excited_brows_00004.png"],
                                      [UIImage imageNamed:@"excited_brows_00005.png"],
                                      [UIImage imageNamed:@"excited_brows_00006.png"]
                                      ];
        
        _browSequenceCloseSequence = @[[UIImage imageNamed:@"excited_brows_00084.png"],
                                       [UIImage imageNamed:@"excited_brows_00085.png"],
                                       [UIImage imageNamed:@"excited_brows_00086.png"],
                                       [UIImage imageNamed:@"excited_brows_00087.png"],
                                       [UIImage imageNamed:@"excited_brows_00088.png"],
                                       [UIImage imageNamed:@"excited_brows_00089.png"],
                                       [UIImage imageNamed:@"excited_brows_00090.png"]
                                       ];
    }
    else {
        _browSequenceOpenSequence = @[[UIImage imageNamed:@"confused_brows_00000.png"],
                                      [UIImage imageNamed:@"confused_brows_00001.png"],
                                      [UIImage imageNamed:@"confused_brows_00002.png"],
                                      [UIImage imageNamed:@"confused_brows_00003.png"],
                                      [UIImage imageNamed:@"confused_brows_00004.png"],
                                      [UIImage imageNamed:@"confused_brows_00005.png"],
                                      [UIImage imageNamed:@"confused_brows_00006.png"]
                                      ];
        
        _browSequenceCloseSequence = @[[UIImage imageNamed:@"confused_brows_00084.png"],
                                       [UIImage imageNamed:@"confused_brows_00085.png"],
                                       [UIImage imageNamed:@"confused_brows_00086.png"],
                                       [UIImage imageNamed:@"confused_brows_00087.png"],
                                       [UIImage imageNamed:@"confused_brows_00088.png"],
                                       [UIImage imageNamed:@"confused_brows_00089.png"],
                                       [UIImage imageNamed:@"confused_brows_00090.png"]
                                       ];
    }
}

- (void)blinkEyes
{
    [self closeEyes];
    [self openEyes];
}

- (void)openEyes
{
    [_lids setAnimationImages:_lidSequenceOpenSequence];
    [_lids setAnimationRepeatCount:1];
    
    [_brows setAnimationImages:_browSequenceOpenSequence];
    [_brows setAnimationRepeatCount:1];
    
    [_lids startAnimating];
    [_brows startAnimating];
    
    
    if (_currentMood == RMBOEyeMoodHappy) {
        [_brows setImage:[UIImage imageNamed:@"happy_brows_00090.png"]];
        [_lids setImage:[UIImage imageNamed:@"happy_lids_00090.png"]];
    }
    else if (_currentMood == RMBOEyeMoodSad) {
        [_brows setImage:[UIImage imageNamed:@"sad_brows_00090.png"]];
        [_lids setImage:[UIImage imageNamed:@"sad_lids_00090.png"]];
    }
    else if (_currentMood == RMBOEyeMoodExcited) {
        [_brows setImage:[UIImage imageNamed:@"excited_brows_00090.png"]];
        [_lids setImage:[UIImage imageNamed:@"excited_lids_00090.png"]];
    }
    else {
        [_brows setImage:[UIImage imageNamed:@"confused_brows_00090.png"]];
        [_lids setImage:[UIImage imageNamed:@"confused_lids_00090.png"]];
    }
    
    
    
}

- (void)closeEyes
{
    [_lids setAnimationImages:_lidSequenceCloseSequence];
    [_lids setAnimationRepeatCount:1];
    
    [_brows setAnimationImages:_browSequenceCloseSequence];
    [_brows setAnimationRepeatCount:1];
    
    [_lids startAnimating];
    [_brows startAnimating];
    
    if (_currentMood == RMBOEyeMoodHappy) {
        [_brows setImage:[UIImage imageNamed:@"happy_brows_00006.png"]];
        [_lids setImage:[UIImage imageNamed:@"happy_lids_00006.png"]];
    }
    else if (_currentMood == RMBOEyeMoodSad) {
        [_brows setImage:[UIImage imageNamed:@"sad_brows_00006.png"]];
        [_lids setImage:[UIImage imageNamed:@"sad_lids_00006.png"]];
    }
    else if (_currentMood == RMBOEyeMoodExcited) {
        [_brows setImage:[UIImage imageNamed:@"excited_brows_00006.png"]];
        [_lids setImage:[UIImage imageNamed:@"excited_lids_00006.png"]];
    }
    else {
        [_brows setImage:[UIImage imageNamed:@"confused_brows_00006.png"]];
        [_lids setImage:[UIImage imageNamed:@"confused_lids_00006.png"]];
    }
}

- (void)placeSubviews
{
    _whites = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_whites];
    
    _pupils = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_pupils];
    
    _lids = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_lids];
    
    _brows = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_brows];
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

// This moves the eye balls based ona  sliding scale
- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated
{

//    xValue = xValue - 0.225;
//    
//    _leftEyeballXPosition = (xValue * (kRMBO_LEFT_EYEBALL_MAX_X - kRMBO_LEFT_EYEBALL_MIN_X)) + kRMBO_LEFT_EYEBALL_MIN_X;
//    
//    _rightEyeballXPosition = (xValue * (kRMBO_RIGHT_EYEBALL_MAX_X - kRMBO_RIGHT_EYEBALL_MIN_X)) + kRMBO_RIGHT_EYEBALL_MIN_X;
//
//    _leftEyeballXPosition = (_leftEyeballXPosition < kRMBO_LEFT_EYEBALL_MIN_X) ? kRMBO_LEFT_EYEBALL_MIN_X : _leftEyeballXPosition;
//    _leftEyeballXPosition = (_leftEyeballXPosition > kRMBO_LEFT_EYEBALL_MAX_X) ? kRMBO_LEFT_EYEBALL_MAX_X : _leftEyeballXPosition;
//    
//    _rightEyeballXPosition = (_rightEyeballXPosition < kRMBO_RIGHT_EYEBALL_MIN_X) ? kRMBO_RIGHT_EYEBALL_MIN_X : _rightEyeballXPosition;
//    _rightEyeballXPosition = (_rightEyeballXPosition > kRMBO_RIGHT_EYEBALL_MAX_X) ? kRMBO_RIGHT_EYEBALL_MAX_X : _rightEyeballXPosition;
//    
//    CGRect leftEyeballRect = [_leftEyeball frame];
//    CGRect rightEyeballRect = [_rightEyeball frame];
//    
//    leftEyeballRect.origin.x = _leftEyeballXPosition;
//    rightEyeballRect.origin.x = _rightEyeballXPosition;
//    
//    NSTimeInterval animationRate = 0.2;
//    
//    if (animated) {
//        [UIView animateWithDuration:animationRate animations:^{
//            _leftEyeball.frame = leftEyeballRect;
//            _rightEyeball.frame = rightEyeballRect;
//    
//        }];
//    }
//    else {
//        _leftEyeball.frame = leftEyeballRect;
//        _rightEyeball.frame = rightEyeballRect;
//    }
}

@end
