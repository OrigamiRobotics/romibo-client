//
//  RMBOEyes_3.h
//  RomiboClient
//
//  Created by Tracy Lakin on 4/28/14.
//  Copyright (c) 2014 com.romibo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, RMBOEyeMood) {
    RMBOEyeMood_Normal,
    RMBOEyeMood_Curious,
    RMBOEyeMood_Excited,
    RMBOEyeMood_Indifferent,
    RMBOEyeMood_Twitterpated,
    RMBOEyeBlink
};


@interface RMBOEyes_3 : UIView

@property (nonatomic, assign) RMBOEyeMood currentMood;

@property (nonatomic, strong) UIImageView * eyes_whites;
@property (nonatomic, strong) UIImageView * eyes_iris;
@property (nonatomic, strong) UIImageView * eyes_highlight;
@property (nonatomic, strong) UIImageView * eyes_lids;


@property (nonatomic, strong) NSTimer *blinkTimer;

- (void)updateEyesForCurrentMood;

- (void)changeEyeMood:(RMBOEyeMood)mood;
- (void)blinkEyes;
- (void)openEyes;
- (void)closeEyes;
- (void)turnOnAutoBlinkWithTimeInterval:(NSTimeInterval)interval;
- (void)turnOffAutoBlink;
- (void)moveEyeballsToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated;


@end
