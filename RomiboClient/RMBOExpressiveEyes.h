//
//  RMBOExpressiveEye.h
//  RomiboClient
//
//  Created by Doug Suriano on 1/2/14.
//  Copyright (c) 2014 com.romibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RMBOEyeMood) {
    RMBOEyeMoodRegular,
    RMBOEyeMoodHappy,
    RMBOEyeMoodSad
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
- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated;
- (void)closeEyes;
- (void)openEyes;
- (void)blinkEyes:(id)sender;

@end
