//
//  RMBOViewController.m
//  RomiboClient
//
//  Created by Doug Suriano on 12/1/13.
//  Copyright (c) 2013 com.romibo. All rights reserved.
//

#import "RMBOViewController.h"
#import "RMBOEye.h"

//#import "RMBOExpressiveMoodEyes.h"
#if OLD_EYES
#import "RMBOExpressiveEyes.h"
#else
#import "RMBOEyes_3.h"
#endif

@interface RMBOViewController ()

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic) dispatch_queue_t videoOutputQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CIDetector *faceDetector;
@property (nonatomic, strong) UIView *faceFoundView;
@property (nonatomic, assign) BOOL connectedToController;
@property (nonatomic, strong) NSDate *settingsHoldStartDate;
@property (nonatomic, strong) NSTimer *settingsTimer;

- (void)updateEyesUsingFeatures:(NSArray *)features;
- (void)sendDictionaryToRobot:(NSDictionary *)dictionary;
- (void)changeMoodOnRobotToMood:(NSInteger)mood;

@end

@implementation RMBOViewController

#define kRMBOLandscapeLeftEXIFOrientationValue @1
#define kRMBOVideoCaptureWidth 640
#define kRMBOAnimationLength 0.4
#define kRMBOEyeWidth 101
#define kRMBOLeftEyeStationaryPosition 167
#define kRMBORightEyeStationaryPosition 324
#define kRMBOLeftEyeRightBarrier 253
#define kRMBORightEyeRightBarrier 410
#define kRMBOServiceType @"origami-romibo"

//Commands
#define kRMBOSpeakPhrase @"kRMBOSpeakPhrase"
#define kRMBOMoveRobot @"kRMBOMoveRobot"
#define kRMBOHeadTilt @"kRMBOHeadTilt"
#define kRMBODebugLogMessage @"kRMBODebugLogMessage"
#define kRMBOTurnInPlaceClockwise @"kRMBOTurnInPlaceClockwise"
#define kRMBOTurnInPlaceCounterClockwise @"kRMBOTurnInPlaceCounterClockwise"
#define kRMBOStopRobotMovement @"kRMBOStopRobotMovement"
#define kRMBOChangeMood @"kRMBOChangeMood"

#define kRMBOSettingsHoldThreshold 3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeViews];
    [self setupMultipeerConnectivity];
    [self setupVoiceSynth];
    [self setupRobotCommunication];
    //[self setupShowkit];
    
    _verisionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [_eyes closeEyes];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupEyeTracking];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self tearDownEyeTracking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeViews
{
    CGRect screen = [[UIScreen mainScreen] applicationFrame];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"starback"]]];
    _blackBackgroundView.frame = screen;
    
    //[_eyes turnOnAutoBlinkWithTimeInterval:7];
}

- (void)setupEyeTracking
{
    NSDictionary *faceDetectorOptions = @{CIDetectorAccuracy : CIDetectorAccuracyLow
                                          };
    
    _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:faceDetectorOptions];
    
    NSError *error = nil;
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPreset640x480];
    
    AVCaptureDevice *device;
    
    AVCaptureDevicePosition desired = AVCaptureDevicePositionFront;
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desired) {
            device = d;
            break;
        }
    }
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (!error) {
        if ([session canAddInput:deviceInput]) {
            [session addInput:deviceInput];
        }
    }
    else {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    NSDictionary *videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCMPixelFormat_32BGRA]};
    [_videoOutput setVideoSettings:videoSettings];
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    _videoOutputQueue = dispatch_queue_create("VideoDataQueue", DISPATCH_QUEUE_SERIAL);
    [_videoOutput setSampleBufferDelegate:self queue:_videoOutputQueue];
    
    if ([session canAddOutput:_videoOutput]) {
        [session addOutput:_videoOutput];
    }
    
    [[_videoOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    [[_previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    
    CALayer *rootLayer = [_previewView layer];
    [rootLayer setMasksToBounds:YES];
    [_previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:_previewLayer];

    [session startRunning];
}

- (void)setupMultipeerConnectivity
{
    MCPeerID *peerId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    _session = [[MCSession alloc] initWithPeer:peerId];
    [_session setDelegate:self];
    
    _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peerId discoveryInfo:@{} serviceType:kRMBOServiceType];
    [_advertiser setDelegate:self];
    [_advertiser startAdvertisingPeer];
    
    
    //_assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:kRMBOServiceType discoveryInfo:@{} session:_session];
    //[_assistant start];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    invitationHandler(YES, _session);
    [_advertiser stopAdvertisingPeer];
}

- (void)setupVoiceSynth
{
    _speechSynth = [[AVSpeechSynthesizer alloc] init];
}

- (void)setupRobotCommunication
{
    _robotDriver = [[RMBODriver alloc] init];
    [_robotDriver setupRobotDriverEnableLogs:YES];
    [_robotDriver setDelegate:self];
    //[RMCore setDelegate:self];
}

- (void)setupShowkit
{
//    [ShowKit login:@"584.romibo_test_client" password:@"iloverobots" withCompletionBlock:^(NSString *const connectionStatus) {
//        NSLog(@"%@", connectionStatus);
//        [ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowkitConnectionChange:) name:SHKConnectionStatusChangedNotification object:nil];
//    }];
}
//
- (void)handleShowkitConnectionChange:(NSNotification *)notification
{
//    [ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];
//    SHKNotification *showNotice ;
//    NSString *value ;
//    NSLog(@"%@",value);
//    showNotice = (SHKNotification *) [notification object];
//    value = (NSString *)showNotice.Value;
//    NSLog(@"%@",value);
//    if ([value isEqualToString:SHKConnectionStatusCallIncoming]) {
//        [ShowKit acceptCall];
//        [self tearDownEyeTracking];
//        [ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];
//        //[ShowKit setState:_previewView forKey:SHKPreviewDisplayViewKey];
//        //[ShowKit setState:SHKVideoLocalPreviewEnabled forKey:SHKPreviewDisplayViewKey];
//        [self speakUtterance:@"Starting video streaming" atSpeechRate:AVSpeechUtteranceDefaultSpeechRate * .8 withVoice:nil];
//    }
//    else if ([value isEqualToString:SHKConnectionStatusInCall]) {
//        [ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];
//    }
//    else if ([value isEqualToString:SHKConnectionStatusCallTerminated]) {
//        [self setupEyeTracking];
//    }
}



- (void)tearDownEyeTracking
{
    [self.eyes turnOffAutoBlink];
    _videoOutput = nil;
    [_previewLayer removeFromSuperlayer];
    _previewLayer = nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    
    if (attachments) {
        CFRelease(attachments);
    }
    
    static NSDictionary *_faceDetectionOptions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _faceDetectionOptions = @{CIDetectorImageOrientation : [NSNumber numberWithInt:1],
                                  CIDetectorSmile : @YES};
    });
    
    NSArray *features = [_faceDetector featuresInImage:ciImage options:_faceDetectionOptions];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateEyesUsingFeatures:features];
    });
}

- (void)updateEyesUsingFeatures:(NSArray *)features
{

    if ([features count] == 0) {
        [UIView animateWithDuration:kRMBOAnimationLength animations:^{
            
        }];
        return;
    }
    

    CIFaceFeature *feature = [features firstObject];
    
//    CGPoint centerPoint = CGPointMake((feature.bounds.size.width / 2) + feature.bounds.origin.x, (feature.bounds.size.height / 2) + feature.bounds.origin.y);
    //NSLog(@"Center Point is X:%f Y:%f", centerPoint.x, centerPoint.y);
    
    //CGFloat calculatedPercentage = centerPoint.x / kRMBOVideoCaptureWidth;
    
    CGFloat calculatedPercentage = feature.bounds.origin.x / kRMBOVideoCaptureWidth;
    CGFloat inversedPercentage = 1.0 - calculatedPercentage;
    
    NSLog(@"Calculated percentage %f, Inversed %f", calculatedPercentage, inversedPercentage);
    
    [_eyes moveEyeballsToX:inversedPercentage andY:0.0 animated:YES];
    
    //[_leftEye moveEyeballToX:inversedPercentage andY:0.5 animated:YES];
    //[_rightEye moveEyeballToX:inversedPercentage andY:0.5 animated:YES];

    
        

}

#pragma mark Robot Commuincation

- (void)speakUtterance:(NSString *)phrase atSpeechRate:(float)speechRate withVoice:(AVSpeechSynthesisVoice *)voice
{
    if (!voice) {
        voice = [AVSpeechSynthesisVoice voiceWithLanguage:[AVSpeechSynthesisVoice currentLanguageCode]];
    }
        
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:phrase];
    [utterance setRate:speechRate];
    [utterance setVoice:voice];
    [_speechSynth speakUtterance:utterance];
}


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected) {
        _connectedToController = YES;
        //[_assistant stop];
        [_advertiser stopAdvertisingPeer];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self speakUtterance:@"Ready to go!" atSpeechRate:AVSpeechUtteranceDefaultSpeechRate *.85 withVoice:nil];
            [_eyes openEyes];
        });
        
        
        
    }
    else {
        _connectedToController = NO;
        [_advertiser startAdvertisingPeer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_robotDriver stopRobot];
            //[self speakUtterance:@"Sorry, seems I have a little stage fright." atSpeechRate:AVSpeechUtteranceDefaultSpeechRate * 0.85 withVoice:nil];
            [_eyes closeEyes];
        });
        
        
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    
    NSDictionary *command = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([command[@"command"] isEqualToString:kRMBOSpeakPhrase]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self speakUtterance:command[@"phrase"] atSpeechRate:[command[@"speechRate"] floatValue] withVoice:nil];
        });
    }
    else if ([command[@"command"] isEqualToString:kRMBOMoveRobot]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (command[@"x"] && command[@"y"]) {
                [_robotDriver driveRobotWithXValue:[command[@"x"] floatValue] andYValue:[command[@"y"] floatValue]];
            }
        });
    }
    else if ([command[@"command"] isEqualToString:kRMBOHeadTilt]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%f", [command[@"angle"] floatValue]);
            if (command[@"angle"]) {
                [_robotDriver tiltHeadToAngle:[command[@"angle"] floatValue]];
            }
        });
    }
    else if ([command[@"command"] isEqualToString:kRMBOTurnInPlaceClockwise]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_robotDriver turnRobotInPlaceClockwise];
        });
    }
    else if ([command[@"command"] isEqualToString:kRMBOTurnInPlaceCounterClockwise]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_robotDriver turnRobotInPlaceCounterClockwise];
        });
    }
    else if ([command[@"command"] isEqualToString:kRMBOStopRobotMovement]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_robotDriver stopRobot];
        });
    }
    else if ([command[@"command"] isEqualToString:kRMBOChangeMood]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeMoodOnRobotToMood:[command[@"mood"] integerValue]];
        });
    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress { }
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error { }
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID { }

- (void)driverConnectedToRobot:(RMBODriver *)driver
{
    [self speakUtterance:@"Connected to Robot" atSpeechRate:AVSpeechUtteranceDefaultSpeechRate withVoice:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)beginSettingsHold:(id)sender
{
    _settingsHoldStartDate = [NSDate date];
    _settingsTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showSettingsPage) userInfo:nil repeats:YES];
    [_settingsHoldLabel setText:[NSString stringWithFormat:@"Hold for %d more seconds", (int)kRMBOSettingsHoldThreshold]];
}

- (IBAction)endedSettingsHold:(id)sender
{
    [_settingsTimer invalidate];
    [_settingsHoldLabel setText:@""];
}

- (void)showSettingsPage
{
    NSTimeInterval timePassed = [_settingsHoldStartDate timeIntervalSinceNow] * -1;
    if ((int)kRMBOSettingsHoldThreshold - (int)timePassed <= 0) {
        [_settingsTimer invalidate];
        _settingsTimer = nil;
        [_settingsHoldLabel setText:@""];
        [_settingsButton setEnabled:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [_blackBackgroundView setFrame:CGRectMake(200, 0, _blackBackgroundView.frame.size.width, _blackBackgroundView.frame.size.height)];
            [_blackBackgroundView setAlpha:0.4];
        }];
    }
    else {
        [_settingsHoldLabel setText:[NSString stringWithFormat:@"Hold for %d more seconds", (int)kRMBOSettingsHoldThreshold - (int)timePassed]];
    }
}

- (IBAction)dismissSettingsAction:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [_blackBackgroundView setFrame:CGRectMake(0, 0, _blackBackgroundView.frame.size.width, _blackBackgroundView.frame.size.height)];
        [_blackBackgroundView setAlpha:1.0];
    }];
    [_settingsButton setEnabled:YES];
}

- (IBAction)sliderAction:(id)sender
{
    UISlider *slider = sender;
    //[_eyes moveEyeballsToX:slider.value andY:0 animated:NO];
    NSLog(@"X value is %f", slider.value);
}

- (void)logMessage:(NSString *)log
{
    [self sendLogMessageToController:log];
}

- (void)sendLogMessageToController:(NSString *)logMessage
{
    NSDictionary *message = @{@"command" : kRMBODebugLogMessage, @"message" : logMessage};
    [self sendDictionaryToRobot:message];
}

- (void)sendDictionaryToRobot:(NSDictionary *)dictionary
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSError *error = nil;
    [_session sendData:data toPeers:_session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
}

//Workaround for Apple bug
- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}


- (void)changeMoodOnRobotToMood:(NSInteger)mood
{
    [self.eyes changeEyeMood:mood];
//    [_eyes blinkEyes];
}





@end