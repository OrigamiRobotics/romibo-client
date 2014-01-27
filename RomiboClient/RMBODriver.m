//
//  RMBODriver.m
//  RomiboClient
//
//  Created by Doug Suriano on 12/7/13.
//  Copyright (c) 2013 com.romibo. All rights reserved.
//

#import "RMBODriver.h"
#import "TestFlight.h"



@interface RMBODriver ()

@property (nonatomic, assign) BOOL sendLogs;

@end

@implementation RMBODriver

#define kRMBODriveRadius 0.161092

#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)setupRobotDriverEnableLogs:(BOOL)logs
{
    [RMCore setDelegate:self];
    _sendLogs = logs;
}

- (void)robotDidConnect:(RMCoreRobot *)robot
{
    if (robot.isDrivable && robot.isHeadTiltable && robot.isLEDEquipped)
    {
        _robot = (RMCoreRobot <HeadTiltProtocol, DriveProtocol, LEDProtocol, RobotMotionProtocol> *)robot;
        // Disable polling of IMU as a workaround for crash bug
        [_robot setRobotMotionEnabled:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_delegate respondsToSelector:@selector(driverConnectedToRobot:)]) {
                [_delegate driverConnectedToRobot:self];
            }
        });
    }
}

- (void)robotDidDisconnect:(RMCoreRobot *)robot
{
    if (robot == _robot) {
        [_robot stopAllMotion];
        _robot = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_delegate respondsToSelector:@selector(driverDisconnected:)]) {
                [_delegate driverDisconnected:self];
            }
        });
    }
}

- (void)driveRobotWithXValue:(float)xValue andYValue:(float)yValue
{
    @try {
        TFLog(@"Driving robot with values %f,%f", xValue, yValue);
        if (xValue > -0.3 && xValue < 0.3) {
            [_robot driveWithRadius:RM_DRIVE_RADIUS_STRAIGHT speed:yValue];
        }
        else {
            if (xValue < 0) {

                [_robot turnByAngle:((xValue * 180) * -1) withRadius:kRMBODriveRadius * -1 completion:^(float heading) {
                    
                }];
            }
            else {
                [_robot turnByAngle:((xValue * 180) * -1) withRadius:kRMBODriveRadius completion:^(float heading) {
                    
                }];
            }
        }

    }
    @catch (NSException *e) {
        TFLog(@"EXCEPTION %@ - %@", [e name], [e reason]);
    }
    
}


- (void)tiltHeadToAngle:(float)angle
{
    TFLog(@"Tilting robot with angle %f", angle);
    if (!_robot.tilting) {
        [_robot tiltToAngle:angle completion:^(BOOL success) {
            if (success) {
                //[_delegate logMessage:@"YES"];
            }
            else {
                //[_delegate logMessage:@"NO"];
            }
        }];
    }
    
}

- (void)stopRobot
{
    [_robot stopAllMotion];
}

- (void)turnRobotInPlaceClockwise
{
    [_robot turnByAngle:180 withRadius:RM_DRIVE_RADIUS_TURN_IN_PLACE completion:^(float heading) {
        
    }];
}

- (void)turnRobotInPlaceCounterClockwise
{
    [_robot turnByAngle:-180 withRadius:RM_DRIVE_RADIUS_TURN_IN_PLACE completion:^(float heading) {
        
    }];
}

@end
