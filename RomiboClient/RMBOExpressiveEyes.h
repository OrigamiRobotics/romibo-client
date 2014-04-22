//
//  RMBOExpressiveEye.h
//  RomiboClient
//
//  Created by Doug Suriano on 1/2/14.
//  Copyright (c) 2014 com.romibo. All rights reserved.
//

#import <UIKit/UIKit.h>

// OLD. Will remove with pending new eye animation.  tracy
//typedef NS_ENUM(NSInteger, RMBOEyeMood) {
//    RMBOEyeMoodRegular,
//    RMBOEyeMoodHappy,
//    RMBOEyeMoodSad
//};

typedef NS_ENUM(NSInteger, RMBOEyeMood) {
    RMBOEyeMoodHappy,
    RMBOEyeMoodExcited,
    RMBOEyeMoodConfused,
    RMBOEyeMoodSad,
    RMBOEyeBlink
};


@interface RMBOExpressiveEyes : UIView

@property (nonatomic, assign) RMBOEyeMood currentMood;

@property (nonatomic, strong) UIImageView *leftEyeBackground;
@property (nonatomic, strong) UIImageView *leftEyeball;
@property (nonatomic, strong) UIImageView *leftEyeLid;

@property (nonatomic, strong) UIImageView *rightEyeBackground;
@property (nonatomic, strong) UIImageView *rightEyeball;
@property (nonatomic, strong) UIImageView *rightEyeLid;

@property (nonatomic, strong) NSTimer *blinkTimer;

- (void)updateEyesForCurrentMood;
// OLD. Will remove with pending new eye animation.  tracy
//- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated;
//- (void)closeEyes;
//- (void)openEyes;
//- (void)blinkEyes:(id)sender;

- (void)changeEyeMood:(RMBOEyeMood)mood;
- (void)blinkEyes;
- (void)openEyes;
- (void)closeEyes;
- (void)turnOnAutoBlinkWithTimeInterval:(NSTimeInterval)interval;
- (void)turnOffAutoBlink;
- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated;


@end
