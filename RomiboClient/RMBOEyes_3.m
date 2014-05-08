//
//  RMBOEyes_3.m
//  RomiboClient
//
//  Created by Doug Suriano on 1/2/14.
//  Copyright (c) 2014 com.romibo. All rights reserved.
//
// This is v2 of the eyes. Not in use anymore

#import "RMBOEyes_3.h"

@interface RMBOEyes_3 ()

@property (nonatomic, assign) CGFloat eyeballXPosition;
@property (nonatomic, assign) CGFloat eyeballYPosition;

@property (nonatomic, strong) NSMutableArray * blinkAnimationSequence;
@property (nonatomic, strong) NSMutableArray * curiousAnimationSequence;
@property (nonatomic, strong) NSMutableArray * excitedAnimationSequence;
@property (nonatomic, strong) NSMutableArray * indifferentAnimationSequence;
@property (nonatomic, strong) NSMutableArray * twitterpatedAnimationSequence;

@end

@implementation RMBOEyes_3

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentMood = RMBOEyeMood_Normal;
        [self placeSubviews];
        [self updateEyesForCurrentMood];
        [self setupAnimationSequences];
//        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

#define kEyes_x  10.0
#define kEyes_y  10.0
#define kEyes_width  (288.0 * 2.0)
#define kEyes_height (144.0 * 2.0)

- (void)placeSubviews
{
    self.eyes_whites = [[UIImageView alloc] initWithFrame:CGRectMake(kEyes_x, kEyes_y, kEyes_width, kEyes_height)];
    [self.eyes_whites setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.eyes_whites];
    
    self.eyes_iris = [[UIImageView alloc] initWithFrame:CGRectMake(kEyes_x, kEyes_y, kEyes_width, kEyes_height)];
    [self.eyes_iris setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.eyes_iris];
    
    self.eyes_highlight = [[UIImageView alloc] initWithFrame:CGRectMake(kEyes_x, kEyes_y, kEyes_width, kEyes_height)];
    [self.eyes_highlight setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.eyes_highlight];
    
    self.eyes_lids = [[UIImageView alloc] initWithFrame:CGRectMake(kEyes_x, kEyes_y, kEyes_width, kEyes_height)];
    [self.eyes_lids setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.eyes_lids];
    
}


- (void)setupAnimationSequences
{
    
    self.blinkAnimationSequence = [NSMutableArray array];
    [self.blinkAnimationSequence addObject:[UIImage imageNamed:@"blink_layer5_eyelids0008"]];
    [self.blinkAnimationSequence addObject:[UIImage imageNamed:@"blink_layer5_eyelids0007"]];
    [self.blinkAnimationSequence addObject:[UIImage imageNamed:@"blink_layer5_eyelids0006"]];
    [self.blinkAnimationSequence addObject:[UIImage imageNamed:@"blink_layer5_eyelids0005"]];
    [self.blinkAnimationSequence addObject:[UIImage imageNamed:@"blink_layer5_eyelids0006"]];
    [self.blinkAnimationSequence addObject:[UIImage imageNamed:@"blink_layer5_eyelids0007"]];
    [self.blinkAnimationSequence addObject:[UIImage imageNamed:@"blink_layer5_eyelids0008"]];

    
    NSString * curiousFileNamePrefix = @"romibo_curious_long";
    self.curiousAnimationSequence = [NSMutableArray array];
    for (int i = 1; i <= 365; i++) {
        NSString * fileName = [curiousFileNamePrefix stringByAppendingString:[NSString stringWithFormat:@"%04d", i]];
        UIImage * image = [UIImage imageNamed:fileName];
        [self.curiousAnimationSequence addObject:image];
    }
    
    NSString * excitedFileNamePrefix = @"Romibo_excited";
    self.excitedAnimationSequence = [NSMutableArray array];
    for (int i = 1; i <= 154; i++) {
        NSString * fileName = [excitedFileNamePrefix stringByAppendingString:[NSString stringWithFormat:@"%04d", i]];
        UIImage * image = [UIImage imageNamed:fileName];
        [self.excitedAnimationSequence addObject:image];
    }

    NSString * indifferentFileNamePrefix = @"romibo_indifferent_long";
    self.indifferentAnimationSequence = [NSMutableArray array];
    for (int i = 1; i <= 300; i++) {
        NSString * fileName = [indifferentFileNamePrefix stringByAppendingString:[NSString stringWithFormat:@"%04d", i]];
        UIImage * image = [UIImage imageNamed:fileName];
        [self.indifferentAnimationSequence addObject:image];
    }
    
    NSString * twitterpatedFileNamePrefix = @"romibotwitterpated";
    self.twitterpatedAnimationSequence = [NSMutableArray array];
    for (int i = 1; i <= 123; i++) {
        NSString * fileName = [twitterpatedFileNamePrefix stringByAppendingString:[NSString stringWithFormat:@"%04d", i]];
        UIImage * image = [UIImage imageNamed:fileName];
        [self.twitterpatedAnimationSequence addObject:image];
    }

}


- (void)updateEyesForCurrentMood
{
    if (_currentMood == RMBOEyeMood_Normal) {
        
        [self.eyes_whites setImage:[UIImage imageNamed:@"blink_layer2_eyewhite0001"]];
        [self.eyes_iris setImage:[UIImage imageNamed:@"blink_layer3_pupil0001"]];
        [self.eyes_highlight setImage:[UIImage imageNamed:@"blink_layer4_highlight0001"]];
        [self.eyes_lids setImage:nil];
    }
}

- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated
{
    NSLog(@"moveEyeBallsToX: %f", xValue);
    
    self.eyeballXPosition = xValue;
    
//    xValue = xValue - 0.225;
//    
//    self.eyeballXPosition = (xValue * (kRMBO_LEFT_EYEBALL_MAX_X - kRMBO_LEFT_EYEBALL_MIN_X)) + kRMBO_LEFT_EYEBALL_MIN_X;
//    
//
//    
//    self.eyeballXPosition = (self.eyeballXPosition < kRMBO_LEFT_EYEBALL_MIN_X) ? kRMBO_LEFT_EYEBALL_MIN_X : self.eyeballXPosition;
//    self.eyeballXPosition = (self.eyeballXPosition > kRMBO_LEFT_EYEBALL_MAX_X) ? kRMBO_LEFT_EYEBALL_MAX_X : self.eyeballXPosition;
    

    CGRect eyeballRect = [self.eyes_iris frame];
    
    eyeballRect.origin.x = self.eyeballXPosition;
    
    NSTimeInterval animationRate = 0.2;
    
    if (animated) {
        [UIView animateWithDuration:animationRate animations:^{
            self.eyes_iris.frame = eyeballRect;
            
        }];
    }
    else {
        self.eyes_iris.frame = eyeballRect;
    }
}

- (void)closeEyes
{
    [_blinkTimer invalidate];
    _blinkTimer = nil;
    [self.eyes_lids setImage:[UIImage imageNamed:@"blink_layer5_eyelids0005"]];
}

- (void)openEyes
{
    [self moveEyeballsToX:0.5 andY:0.5 animated:NO];
    _blinkTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(blinkEyes) userInfo:nil repeats:YES];
    [self.eyes_lids setImage:nil];
    [self blinkEyes];
}

- (void)blinkEyes
{
    NSLog(@"blinkEyes");
    [self.eyes_lids setAnimationImages:_blinkAnimationSequence];
    [self.eyes_lids setAnimationRepeatCount:1];
    [self.eyes_lids setAnimationDuration:0.3];
    
    [self.eyes_lids startAnimating];
}

- (void)curiousAnimation
{
    NSLog(@"curiousAnimation");
    [self.eyes_lids setAnimationImages:self.curiousAnimationSequence];
    [self.eyes_lids setAnimationRepeatCount:1];
    [self.eyes_lids setAnimationDuration:15.0];
    
    [self.eyes_lids startAnimating];
}

- (void)excitedAnimation
{
    NSLog(@"excitedAnimation");
    [self.eyes_lids setAnimationImages:self.excitedAnimationSequence];
    [self.eyes_lids setAnimationRepeatCount:1];
    [self.eyes_lids setAnimationDuration:6.0];
    
    [self.eyes_lids startAnimating];
}

- (void)indifferentAnimation
{
    NSLog(@"indifferentAnimation");
    [self.eyes_lids setAnimationImages:self.indifferentAnimationSequence];
    [self.eyes_lids setAnimationRepeatCount:1];
    [self.eyes_lids setAnimationDuration:12.0];
    
    [self.eyes_lids startAnimating];
}

- (void)twitterpatedAnimation
{
    NSLog(@"twitterpatedAnimation");
    [self.eyes_lids setAnimationImages:self.twitterpatedAnimationSequence];
    [self.eyes_lids setAnimationRepeatCount:1];
    [self.eyes_lids setAnimationDuration:5.0];
    
    [self.eyes_lids startAnimating];
}

- (void)changeEyeMood:(RMBOEyeMood)mood
{
    [self turnOffAutoBlink];
    _currentMood = mood;
    
    if (_currentMood == RMBOEyeMood_Normal) {
        [self openEyes];
    }
    else if (_currentMood == RMBOEyeMood_Curious) {
        [self curiousAnimation];
    }
    else if (_currentMood == RMBOEyeMood_Excited) {
        [self excitedAnimation];
     }
    else if (_currentMood == RMBOEyeMood_Indifferent) {
        [self indifferentAnimation];
    }
    else if (_currentMood == RMBOEyeMood_Twitterpated) {
        [self twitterpatedAnimation];
    }
    else if (_currentMood == RMBOEyeBlink) {
        [self blinkEyes];
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
