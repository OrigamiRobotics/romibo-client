//
//  RMBOExpressiveMoodEyes.h
//  RomiboClient
//
//  Created by Doug Suriano on 2/19/14.
//  Copyright (c) 2014 com.romibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBOExpressiveMoodEyes : UIView

typedef NS_ENUM(NSInteger, RMBOEyeMood) {
    RMBOEyeMoodHappy,
    RMBOEyeMoodExcited,
    RMBOEyeMoodConfused,
    RMBOEyeMoodSad
};

- (void)changeEyeMood:(RMBOEyeMood)mood;
- (void)blinkEyes;
- (void)openEyes;
- (void)closeEyes;
- (void)turnOnAutoBlinkWithTimeInterval:(NSTimeInterval)interval;
- (void)turnOffAutoBlink;
- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated;



@end
