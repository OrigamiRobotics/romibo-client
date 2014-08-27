//
//  RMBOViewController.h
//  RomiboClient
//
//  Created by Doug Suriano on 12/1/13.
//  Copyright (c) 2013 com.romibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "RMBODriver.h"

#define OLD_EYES 1
#if OLD_EYES
    #import "RMBOExpressiveMoodEyes.h"
#else
    #import "RMBOEyes_3.h"
#endif

@import AVFoundation;
@import CoreImage;

@class RMBODriver;

@interface RMBOViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate,
                                                    MCSessionDelegate,
                                                    MCNearbyServiceAdvertiserDelegate,
                                                    RMBODriverDelegate>

@property (nonatomic, weak) IBOutlet UIView *previewView;
@property (nonatomic, weak) IBOutlet UIView *blackBackgroundView;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) MCSession *session;
//@property (nonatomic, strong) MCAdvertiserAssistant *assistant;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynth;
@property (nonatomic, strong) RMBODriver *robotDriver;

@property (nonatomic, weak) IBOutlet UILabel *debugLabel;

@property (nonatomic, weak) IBOutlet UIButton *settingsButton;
@property (nonatomic, weak) IBOutlet UILabel *settingsHoldLabel;
@property (nonatomic, weak) IBOutlet UILabel *verisionLabel;
// ETJ DEBUG
@property unsigned int currentMood;
@property (weak, nonatomic) IBOutlet UIButton *etjDebugButton;
- (IBAction)etjDebugButtonAction:(id)sender;

// END DEBUG

#if !OLD_EYES
@property (nonatomic, weak) IBOutlet RMBOEyes_3 *eyes;
#else
@property (nonatomic, weak) IBOutlet RMBOExpressiveMoodEyes *eyes;
#endif

- (IBAction)sliderAction:(id)sender;

- (void)customizeViews;
- (void)setupEyeTracking;
- (void)setupMultipeerConnectivity;
- (void)setupVoiceSynth;
- (void)setupRobotCommunication;

//- (void)setupShowkit;
//- (void)handleShowkitConnectionChange:(NSNotification *)notification;
//- (void)handleShowkitConnectionChange;

- (void)tearDownEyeTracking;

- (void)speakUtterance:(NSString *)phrase atSpeechRate:(float)speechRate withVoice:(AVSpeechSynthesisVoice *)voice;

- (IBAction)beginSettingsHold:(id)sender;
- (IBAction)endedSettingsHold:(id)sender;
- (IBAction)dismissSettingsAction:(id)sender;
- (void)showSettingsPage;
- (void)sendLogMessageToController:(NSString *)logMessage;



@end
