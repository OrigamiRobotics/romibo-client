//
//  RMBODriver.m
//  RomiboClient
//
//  Created by Doug Suriano on 12/7/13.
//  Copyright (c) 2013 com.romibo. All rights reserved.
//

#import "RMBODriver.h"
//#import "TestFlight.h"



@interface RMBODriver ()

@property (nonatomic, assign) BOOL sendLogs;

@end

@implementation RMBODriver


//#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

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

#define kSpeed_turnInPlace_metersPerSecond  0.3f
#define kSpeed_MaxDrive_metersPerSecond  1.0f

#define kRMBO_MAX_DriveRadius 0.5f
#define kRMBO_MIN_DriveRadius 0.2f

#define kRMBO_StraightAheadWidth 0.1f



// xValue and yValue range +- 1.0 float

- (void)driveRobotWithXValue:(float)xValue andYValue:(float)yValue
{
    if (yValue > kSpeed_MaxDrive_metersPerSecond)
        yValue = kSpeed_MaxDrive_metersPerSecond;

//    NSLog(@"Driving robot with x: %f  y: %f", xValue, yValue);
    float xFabs = fabsf(xValue);

    //TFLog(@"Driving robot with values %f,%f", xValue, yValue);
    if (xFabs < kRMBO_StraightAheadWidth) {
        [_robot driveWithRadius:RM_DRIVE_RADIUS_STRAIGHT speed:yValue];
        NSLog(@"Drive Straight");
    }
    else {

        float driveRadius = kRMBO_MAX_DriveRadius - (xFabs * kRMBO_MAX_DriveRadius); // harder turn = smaller radius
        if (driveRadius < kRMBO_MIN_DriveRadius)
            driveRadius = kRMBO_MIN_DriveRadius;

        if (xValue < 0) {

            NSLog(@"Turn LEFT with radius: %f  speed: %f", driveRadius, yValue);

            [_robot driveWithRadius:driveRadius speed:yValue];  // turnByAngle call did not work well.
        }
        else {
            driveRadius *= -1.0f;
            NSLog(@"Turn RIGHT with radius: %f  speed: %f", driveRadius, yValue);

            [_robot driveWithRadius:driveRadius speed:yValue];  // turnByAngle call did not work well.
        }
    }
}


- (void)tiltHeadToAngle:(float)angle
{
    //TFLog(@"Tilting robot with angle %f", angle);
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
    [_robot turnByAngle:-180
             withRadius:RM_DRIVE_RADIUS_TURN_IN_PLACE
                  speed: kSpeed_turnInPlace_metersPerSecond
        finishingAction: RMCoreTurnFinishingActionStopDriving
             completion:^(BOOL completed, float heading) {    }
     ];

    
//    [_robot turnByAngle:180 withRadius:RM_DRIVE_RADIUS_TURN_IN_PLACE completion:^(BOOL completed, float heading) {
//        
//    }];
}

- (void)turnRobotInPlaceCounterClockwise
{
    [_robot turnByAngle:
     180
             withRadius:RM_DRIVE_RADIUS_TURN_IN_PLACE
                  speed: kSpeed_turnInPlace_metersPerSecond
        finishingAction: RMCoreTurnFinishingActionStopDriving
             completion:^(BOOL completed, float heading) {    }
     ];

    
//    [_robot turnByAngle:-180 withRadius:RM_DRIVE_RADIUS_TURN_IN_PLACE completion:^(BOOL completed, float heading) {
//        
//    }];
}

@end
