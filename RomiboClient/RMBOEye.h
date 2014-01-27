//
//  RMBOEye.h
//  RomiboClient
//
//  Created by Doug Suriano on 12/9/13.
//  Copyright (c) 2013 com.romibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBOEye : UIView

@property (nonatomic, strong) UIView *eyeContainer;
@property (nonatomic, strong) UIImageView *eyeball;

@property (nonatomic, readonly) CGFloat eyeballXPosition;
@property (nonatomic, readonly) CGFloat eyeballYPosition;

- (void)moveEyeballToX:(CGFloat)xValue andY:(CGFloat)yValue animated:(BOOL)animated;

@end
