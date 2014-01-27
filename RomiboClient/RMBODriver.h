//
//  RMBODriver.h
//  RomiboClient
//
//  Created by Doug Suriano on 12/7/13.
//  Copyright (c) 2013 com.romibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RMCore/RMCore.h>

@class RMBODriver;
@protocol RMBODriverDelegate <NSObject>

@optional
- (void)driverConnectedToRobot:(RMBODriver *)driver;
- (void)driverDisconnected:(RMBODriver *)driver;
- (void)logMessage:(NSString *)log;

@end

@interface RMBODriver : NSObject <RMCoreDelegate>

@property (nonatomic, strong) RMCoreRobot<HeadTiltProtocol, DriveProtocol, LEDProtocol, RobotMotionProtocol> *robot;
@property (nonatomic, weak) id <RMBODriverDelegate> delegate;

- (void)setupRobotDriverEnableLogs:(BOOL)logs;
- (void)driveRobotWithXValue:(float)x andYValue:(float)y;
- (void)tiltHeadToAngle:(float)angle;
- (void)stopRobot;
- (void)turnRobotInPlaceClockwise;
- (void)turnRobotInPlaceCounterClockwise;

@end
