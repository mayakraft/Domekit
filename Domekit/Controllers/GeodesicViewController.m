//
//  ViewController.m
//  Domekit
//
//  Created by Robby on 5/3/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import <CoreMotion/CoreMotion.h>

#import "AppDelegate.h"

#import "GeodesicViewController.h"

#import "DiagramViewController.h"

// NAVIGATION BAR
#import "SWRevealViewController.h"
#import "ExtendedNavBarView.h"
// VIEWS
#import "GeodesicView.h"
#import "FrequencyControlView.h"
#import "SliceControlView.h"
#import "ScaleControlView.h"
#import "ScaleFigureView.h"
// DATA MODELS
#import "GeodesicModel.h"
#import "CameraAnimation.h"
//#import "ValueAnimation.h"
// GESTURES
#import "RotationGestureRecognizer.h"


// this appears to be the best way to grab orientation. if this becomes formalized, just make sure the orientations match
#define DEVICE_ORIENTATION [[UIApplication sharedApplication] statusBarOrientation] //enum  1(NORTH)  2(SOUTH)  3(EAST)  4(WEST)

#define NAVBAR_HEIGHT 88
#define EXT_NAVBAR_HEIGHT 57

#define ORTHO_ANIM_TIME 0.266f

#warning TODO
//TODO: implement subclassed gesture delegates
// get rid of the gesture interaction ontop of UIKit elements

@interface GeodesicViewController () <ValueAnimationDelegate> {
    GeodesicView *geodesicView;
    GeodesicModel *geodesicModel;
    CMMotionManager *motionManager;
    
    // Bottom screen controls
    FrequencyControlView *frequencyControlView;
    SliceControlView *sliceControlView;
    ScaleControlView *scaleControlView;
    ScaleFigureView *scaleFigureView;
    
    // rotation and touch handling
    GLKQuaternion gestureRotation;
    RotationGestureRecognizer *touchRotationGesture;
}

@property (nonatomic) NSUInteger perspective;
@property (weak) UISegmentedControl *topMenu;
@end

@implementation GeodesicViewController

-(id) initWithPolyhedra:(unsigned int)solidType{
    self = [super init];
    if(self){
        _solidType = solidType;
        geodesicModel = [[GeodesicModel alloc] initWithFrequency:1 Solid:_solidType];
        [self initSensors];
    }
    return self;
}
-(id) init{
    self = [super init];
    if(self){
        geodesicModel = [[GeodesicModel alloc] initWithFrequency:1 Solid:0];
        [self initSensors];
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        geodesicModel = [[GeodesicModel alloc] initWithFrequency:1 Solid:0];
        [self initSensors];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        geodesicModel = [[GeodesicModel alloc] initWithFrequency:1 Solid:0];
        [self initSensors];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initRevealController];
    
    BOOL gyro = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] boolValue];
    [self setOrientationSensorsEnabled:gyro];

    _sessionScale = 11.0;
    [self updateUI];

    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height - NAVBAR_HEIGHT;

    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    
    geodesicView = [[GeodesicView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 44) context:context];
    [self setView:geodesicView];
    //    geodesicView = [[GeodesicView alloc] initWithFrame:CGRectMake(0, EXT_NAVBAR_HEIGHT, w, (h + NAVBAR_HEIGHT * .5) - h*.25 - EXT_NAVBAR_HEIGHT) context:context];
    //    [self.view addSubview:geodesicView];
    
    [geodesicView setGeodesicModel:geodesicModel];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *makeButton = [[UIBarButtonItem alloc] initWithTitle:@"Make" style:UIBarButtonItemStylePlain target:self action:@selector(makeDiagram)];
    self.navigationItem.rightBarButtonItem = makeButton;
    
    ExtendedNavBarView *extendedNavBar = [[ExtendedNavBarView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, EXT_NAVBAR_HEIGHT)];
    [[extendedNavBar segmentedControl] addTarget:self action:@selector(topMenuChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:extendedNavBar];
    _topMenu = [extendedNavBar segmentedControl];


    // BOTTOM CONTROLS
    CGRect controllerFrame = CGRectMake(0, h*.75 + NAVBAR_HEIGHT * .5, w, h*.25);
    frequencyControlView = [[FrequencyControlView alloc] initWithFrame:controllerFrame];
    [frequencyControlView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:frequencyControlView];
    [[frequencyControlView segmentedControl] addTarget:self action:@selector(frequencyControlChange:) forControlEvents:UIControlEventValueChanged];
    
    sliceControlView = [[SliceControlView alloc] initWithFrame:controllerFrame];
    [sliceControlView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sliceControlView];
    [[sliceControlView slider] addTarget:self action:@selector(sliceControlChange:) forControlEvents:UIControlEventValueChanged];

    scaleControlView = [[ScaleControlView alloc] initWithFrame:CGRectMake(0, h*.7 + NAVBAR_HEIGHT * .5, w, h*.3)];
    [scaleControlView setBackgroundColor:[UIColor clearColor]];
    [scaleControlView setViewController:self];
    [self.view addSubview:scaleControlView];
    [[scaleControlView slider] addTarget:self action:@selector(scaleControlChange:) forControlEvents:UIControlEventValueChanged];
    [[scaleControlView slider] addTarget:self action:@selector(scaleControlChangeEnd:) forControlEvents:UIControlEventTouchUpInside];
    
    // HUMAN CAT FIGURE
    CGPoint sphereCenter = CGPointMake(geodesicView.frame.size.width*.5, geodesicView.frame.size.height*.5);
    CGFloat sphereRadius = geodesicView.frame.size.width * .4;
    scaleFigureView = [[ScaleFigureView alloc] initWithFrame:CGRectMake(sphereCenter.x - sphereRadius, sphereCenter.y - sphereRadius, sphereRadius*2, sphereRadius*2)];
    [self.view addSubview:scaleFigureView];
    [self.view sendSubviewToBack:scaleFigureView];
    
    [sliceControlView setHidden:YES];
    [scaleControlView setHidden:YES];
//    [scaleFigureView setHidden:YES];
    [scaleFigureView setAlpha:0.0];
    
    [geodesicView setSphereOverride:YES];
    
    
    // TOUCH GESTURES
    gestureRotation = GLKQuaternionIdentity;
    
    touchRotationGesture = [[RotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureHandler:)];
    [touchRotationGesture setMaximumNumberOfTouches:1];
//    [rotationGesture setDelegate:self];
    float gestureTop = extendedNavBar.frame.origin.y + extendedNavBar.frame.size.height;
    float gestureHeight = controllerFrame.origin.y - gestureTop;
    UIView *gestureView = [[UIView alloc] initWithFrame:CGRectMake(0, gestureTop, [[UIScreen mainScreen] bounds].size.width, gestureHeight)];
    [self.view addSubview:gestureView];
    [gestureView addGestureRecognizer:touchRotationGesture];
    
    
    [self setPerspective:0];
    [self.view bringSubviewToFront:extendedNavBar];
//    NSLog(@"SAVED DOMES: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"saved"]);
}
-(void) initRevealController{
    SWRevealViewController *revealController = self.revealViewController;
    //    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    // TODO: BRING THIS BACK
    //    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    //TODO: this is not dynamically sized
    UIButton *revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22*3/2, 17*3/2)];
    [revealButton setBackgroundImage:[UIImage imageNamed:@"reveal-icon"] forState:UIControlStateNormal];
    [revealButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *revealBarButton = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
    [self.navigationItem setLeftBarButtonItem:revealBarButton];
}

-(void) makeDiagram{
    DiagramViewController *dVC = [[DiagramViewController alloc] init];
    [geodesicModel makeLineClasses];
    [dVC setMaterials:@{@"lines" : [geodesicModel lineLengthValues],
                        @"lineQuantities" : [geodesicModel lineTypeQuantities],
                        @"points" : [geodesicModel joints]
                        }];
    [dVC setTitle:[self title]];
    [dVC setScale:((_sessionScale - 1.0) * .5)];
    [dVC setGeodesicModel:geodesicModel];
    [self.navigationController pushViewController:dVC animated:YES];
}

#pragma mark- SINGLE VALUE ANIMATION DELEGATE
-(void) valueAnimationDidUpdate:(ValueAnimation *)sender{
//    if([[sender name] isEqualToString:@"GYRO"]){ }
//    else if([[sender name] isEqualToString:@"GESTURE"]){ }
    
}
-(void) valueAnimationDidStop:(ValueAnimation *)sender{
    if([[sender name] isEqualToString:@"GYRO"]){

    }
    else if([[sender name] isEqualToString:@"GESTURE"]){
//        gestureRotation = GLKQuaternionIdentity;
        gestureRotation = [(CameraAnimation*)sender quaternion];
        [geodesicView setGestureRotation:gestureRotation];
    }
    else if([[sender name] isEqualToString:@"FADE"]){
        [geodesicView setSphereAlpha:[sender value]];
        [scaleFigureView setAlpha:1.0 - (([sender value]-.5) * 2.0)];
    }
    else if ([[sender name] isEqualToString:@"SLICE"]){
        [geodesicView setSlicedSphereAlpha:[sender value]];
    }
    
//    [geodesicView setCameraRadius:[geodesicView cameraRadius]];
    
//    [geodesicView setAnimationFlag:NO];

    // END
    NSMutableArray *anim = [_animations mutableCopy];
    [anim removeObject:sender];
    _animations = anim;
    sender = nil;
}

#pragma mark- USER INTERFACE HANDLERS
-(void) rotationGestureHandler:(RotationGestureRecognizer*)sender{
    static GLKQuaternion start, cumulative;
    if([sender state] == 1){
        start = gestureRotation;
        cumulative = GLKQuaternionIdentity;
    }
    if([sender state] == 2){
        cumulative = GLKQuaternionMultiply(cumulative, [sender rotationInView:geodesicView]);//[sender rotationInView:geodesicView]);
        gestureRotation = GLKQuaternionMultiply(cumulative, start);
        [geodesicView setGestureRotation:gestureRotation];
    }
}

-(void) topMenuChange:(UISegmentedControl*)sender{
    if(!_animations)
        _animations = @[];
    
    // CAMERA ANIMATIONS
    // begins now with duration set by ORTHO_ANIM_TIME
    if(_perspective == 0 && [sender selectedSegmentIndex] != 0){
        CameraAnimation *gyroOrientationAnimation = [[CameraAnimation alloc] initWithName:@"GYRO" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0 EndValue:0];
        [gyroOrientationAnimation setStartOrientation:GLKQuaternionMakeWithMatrix4([self getDeviceOrientationMatrix])];
        [gyroOrientationAnimation setEndOrientation:GLKQuaternionIdentity];
        _animations = [_animations arrayByAddingObject:gyroOrientationAnimation];

        CameraAnimation *gestureOrientationAnimation = [[CameraAnimation alloc] initWithName:@"GESTURE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0 EndValue:0];
        [gestureOrientationAnimation setStartOrientation:gestureRotation];
        [gestureOrientationAnimation setEndOrientation:GLKQuaternionNormalize(GLKQuaternionMake(0, gestureRotation.y, 0, gestureRotation.w))];
        _animations = [_animations arrayByAddingObject:gestureOrientationAnimation];
        
        ValueAnimation *sliceAnimation = [[ValueAnimation alloc] initWithName:@"SLICE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:1.0 EndValue:0.0];
        _animations = [_animations arrayByAddingObject:sliceAnimation];
    }
    if(_perspective != 0 && [sender selectedSegmentIndex] == 0){
        CameraAnimation *gyroOrientationAnimation = [[CameraAnimation alloc] initWithName:@"GYRO" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0 EndValue:0];
        [gyroOrientationAnimation setStartOrientation:GLKQuaternionIdentity];
        [gyroOrientationAnimation setEndOrientation:GLKQuaternionMakeWithMatrix4([self getDeviceOrientationMatrix])];
        [gyroOrientationAnimation setReverse:YES];
        _animations = [_animations arrayByAddingObject:gyroOrientationAnimation];

        CameraAnimation *gestureOrientationAnimation = [[CameraAnimation alloc] initWithName:@"GESTURE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0 EndValue:0];
        [gestureOrientationAnimation setStartOrientation:gestureRotation];//rotation];
        [gestureOrientationAnimation setEndOrientation:gestureRotation];
        [gestureOrientationAnimation setReverse:YES];
        _animations = [_animations arrayByAddingObject:gestureOrientationAnimation];

        ValueAnimation *sliceAnimation = [[ValueAnimation alloc] initWithName:@"SLICE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0.0 EndValue:1.0];
        _animations = [_animations arrayByAddingObject:sliceAnimation];
    }
    if(_perspective != 2 && [sender selectedSegmentIndex] == 2){
        ValueAnimation *fadeAnimation = [[ValueAnimation alloc] initWithName:@"FADE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:1.0 EndValue:.5];
        _animations = [_animations arrayByAddingObject:fadeAnimation];
    }
    if(_perspective ==2 && [sender selectedSegmentIndex] != 2){
        ValueAnimation *fadeAnimation = [[ValueAnimation alloc] initWithName:@"FADE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:.5 EndValue:1.0];
        _animations = [_animations arrayByAddingObject:fadeAnimation];
    }
    if([sender selectedSegmentIndex] == 0){
        [frequencyControlView setHidden:NO];
        [sliceControlView setHidden:YES];
        [scaleControlView setHidden:YES];
//        [scaleFigureView setHidden:YES];
        [geodesicView setSphereOverride:YES];
//        [geodesicView setSphereAlpha:1.0];
//        [touchRotationGesture setEnabled:YES];
        [touchRotationGesture setLockToY:NO];
    }
    else if([sender selectedSegmentIndex] == 1){
        [frequencyControlView setHidden:YES];
        [sliceControlView setHidden:NO];
        [scaleControlView setHidden:YES];
//        [scaleFigureView setHidden:YES];
        [geodesicView setSphereOverride:NO];
//        [geodesicView setSphereAlpha:1.0];
//        [touchRotationGesture setEnabled:NO];
        [touchRotationGesture setLockToY:YES];
    }
    else if([sender selectedSegmentIndex] == 2){
        [frequencyControlView setHidden:YES];
        [sliceControlView setHidden:YES];
        [scaleControlView setHidden:NO];
//        [scaleFigureView setHidden:NO];
        [geodesicView setSphereOverride:NO];
//        [geodesicView setSphereAlpha:0.5];
//        [touchRotationGesture setEnabled:NO];
        [touchRotationGesture setLockToY:YES];
//        [geodesicView setAlphaHiddenFaces:.2];
        [geodesicModel calculateLongestStrutLength];
        [self updateUI];
    }
    // active screen / menu selection stored in perspective
    [self setPerspective:[sender selectedSegmentIndex]];
}
-(void) frequencyControlChange:(UISegmentedControl*)sender{
    unsigned int frequency = (unsigned int)([sender selectedSegmentIndex] + 1);
    //    [geodesicView setGeodesicModel:nil];
    [[sliceControlView slider] setValue:1.0];
    [geodesicModel setFrequency:frequency];
    //    NSLog(@"SLICERS: %@",[geodesicModel slicePoints]);
    [self updateUI];
    //    [geodesicView setGeodesicModel:geodesicModel];
    [geodesicView setNeedsDisplay];
}
-(void) sliceControlChange:(UISlider*)sender{
    //TODO: this is happening every frame, even when the frequency isn't changed
    //    NSArray *sliceCounts = geodesicModel.faceAltitudeCountsCumulative;
    int unit = sender.value * ([geodesicModel frequencyDenominator] - 1);
    if(unit+1 >= [geodesicModel frequencyDenominator]){
        // numerator must be smaller than or equal to denominator
        [geodesicModel setSphere];
        [self updateUI];
        return;
    }
//    [geodesicView setSliceAmount:[geodesicModel.faceAltitudeCountsCumulative[unit] unsignedIntValue]];
    [geodesicModel setFrequencyNumerator:unit+1];
    [self updateUI];
}
-(void) scaleControlChange:(UISlider*)sender{
    float SENSITIVITY = 0.3f;
    static float baseScale;
    if([sender state] == 0)  // touches begin
        baseScale = _sessionScale;
    else
        _sessionScale = baseScale * pow(baseScale,(sender.value - .5) * SENSITIVITY);
    if(_sessionScale > 1000000.0)
        _sessionScale = 1000000.0;
    [self updateUI];
}
-(void) scaleControlChangeEnd:(UISlider*)sender{
    [UIView beginAnimations:@"scaleReset" context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [sender setValue:0.5 animated:YES];
    [UIView commitAnimations];
}
-(void) userInputHeight:(float)value{
    _sessionScale = value / [geodesicModel domeHeight] + 1.0;
}
-(void) userInputFloorDiameter:(float)value{
    _sessionScale = value / [geodesicModel domeFloorDiameter] + 1.0;
}
-(void) userInputLongestStrut:(float)value{
    _sessionScale = value / [geodesicModel longestStrutLength] + 1.0;
}

#pragma mark- MODEL INTERFACE

-(void) setSolidType:(unsigned int)solidType{
    _solidType = solidType;
    [geodesicModel setSolid:solidType];
    //    NSLog(@"SLICERS: %@",[geodesicModel slicePoints]);
    [self updateUI];
}
-(void) newPolyhedra:(unsigned int)solidType{
    _solidType = solidType;
    [geodesicModel setSolid:solidType];
    [geodesicModel setFrequency:1];
    [geodesicModel setSphere];
    _sessionScale = 11.0;
    [geodesicView setSphereOverride:YES];
    [geodesicView setSphereAlpha:1.0];
    [self setPerspective:0];
    // reset top menu
    [_topMenu setSelectedSegmentIndex:0];
    [frequencyControlView setHidden:NO];
    [sliceControlView setHidden:YES];
    [scaleControlView setHidden:YES];
//    [scaleFigureView setHidden:YES];
    [scaleFigureView setAlpha:0.0];
    [geodesicView setSphereOverride:YES];
    [touchRotationGesture setLockToY:NO];
    [[sliceControlView slider] setValue:1.0];
    [[frequencyControlView segmentedControl] setSelectedSegmentIndex:0];
    [self updateUI];
    //    [self setPerspective:0];
}

-(void) storeCurrentDome{
    NSMutableArray *saved = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saved"] mutableCopy];
    NSDictionary *dome = @{
                           @"date": [NSDate date],
                           @"solid": @(geodesicModel.solid),
                           @"frequency":@(geodesicModel.frequency),
                           @"numerator":@(geodesicModel.frequencyNumerator),
                           @"denominator":@(geodesicModel.frequencyDenominator),
                           @"scale":@(_sessionScale)};
    [saved addObject:dome];
    //    NSLog(@"ADDING DOME:\n%@",dome);
    [[NSUserDefaults standardUserDefaults] setObject:saved forKey:@"saved"];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateUserPreferencesAcrossApp];
}
-(void) loadDome:(NSDictionary *)dome{
    [geodesicView setGeodesicModel:nil];
    geodesicModel = [[GeodesicModel alloc] initWithFrequency:[[dome objectForKey:@"frequency"] intValue]
                                                       Solid:[[dome objectForKey:@"solid"] intValue]
                                                        Crop:[[dome objectForKey:@"numerator"] intValue]];
    _solidType = geodesicModel.solid;
    _sessionScale = [[dome objectForKey:@"scale"] floatValue];
    [geodesicModel calculateLongestStrutLength];
    [geodesicView setGeodesicModel:geodesicModel];
    [frequencyControlView.segmentedControl setSelectedSegmentIndex:[[dome objectForKey:@"frequency"] intValue] - 1];
    float slicePercent = (float)[[dome objectForKey:@"numerator"] intValue] / [[dome objectForKey:@"denominator"] intValue];
    [sliceControlView.slider setValue:slicePercent];
}

-(void) setPerspective:(NSUInteger)perspective{
    _perspective = perspective;
    if(_perspective == 0){
        [geodesicView setFieldOfView:56.782191];
        [geodesicView setCameraRadius:2];
        [geodesicView setCameraRadiusFix:0];
//        [geodesicView setFieldOfView:45 + 45 * atanf(geodesicView.aspectRatio)];
    }
//    if(_perspective == 1)
//        [geodesicView setFieldOfView:2.122105];
//    if(_perspective == 2)
//        [geodesicView setFieldOfView:2.122105];
}

-(void) updateUI{
//    NSLog(@"updating UI, and session scale is : %f",_sessionScale);
    // update NavBar Title
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    if([geodesicModel frequencyNumerator] == [geodesicModel frequencyDenominator]){
        if(_solidType == 0)
            [self setTitle:[NSString stringWithFormat:@"%dV ICO SPHERE",[geodesicModel frequency] ]];
        if(_solidType == 1)
            [self setTitle:[NSString stringWithFormat:@"%dV OCTA SPHERE",[geodesicModel frequency] ]];
    }
    else{
        if(_solidType == 0)
            [self setTitle:[NSString stringWithFormat:@"%dV %d/%d ICO DOME",[geodesicModel frequency], [geodesicModel frequencyNumerator], [geodesicModel frequencyDenominator]]];
        if(_solidType == 1)
            [self setTitle:[NSString stringWithFormat:@"%dV %d/%d OCTA DOME",[geodesicModel frequency], [geodesicModel frequencyNumerator], [geodesicModel frequencyDenominator]]];
    }
    ;
    [[scaleControlView floorDiameterTextField] setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[geodesicModel domeFloorDiameter] * (_sessionScale - 1.0)]];
    [[scaleControlView heightTextField] setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[geodesicModel domeHeight] * (_sessionScale - 1.0)]];
    [[scaleControlView strutTextField] setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[geodesicModel longestStrutLength] * (_sessionScale - 1.0)]];
    NSString *unitsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"units"];
    if([unitsString isEqualToString:@"feet"] || [unitsString isEqualToString:@"feet + inches"])
        [scaleFigureView setMeters:NO];
    if([unitsString isEqualToString:@"meters"] || [unitsString isEqualToString:@"meters + centimeters"])
        [scaleFigureView setMeters:YES];
    [scaleFigureView setSessionScale:(_sessionScale - 1.0)];
    [scaleFigureView setDomeHeight:geodesicModel.domeHeight];
}
-(void) iOSKeyboardHide{
    [[scaleControlView floorDiameterTextField] setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[geodesicModel domeFloorDiameter] * (_sessionScale - 1.0)]];
    [[scaleControlView heightTextField] setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[geodesicModel domeHeight] * (_sessionScale - 1.0)]];
    [[scaleControlView strutTextField] setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[geodesicModel longestStrutLength] * (_sessionScale - 1.0)]];
    [scaleFigureView setSessionScale:(_sessionScale - 1.0)];
    [scaleFigureView setDomeHeight:geodesicModel.domeHeight];
}

-(void) iOSKeyboardShow{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:6];

    float one = [geodesicModel domeHeight] * (_sessionScale - 1.0);
    float two = [geodesicModel domeFloorDiameter] * (_sessionScale - 1.0);
    float three = [geodesicModel longestStrutLength] * (_sessionScale - 1.0);
    
    NSString *oneString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:one]];
    NSString *twoString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:two]];
    NSString *threeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:three]];

    [[scaleControlView heightTextField] setText:oneString];
    [[scaleControlView floorDiameterTextField] setText:twoString];
    [[scaleControlView strutTextField] setText:threeString];
}

#pragma mark- ORIENTATION

-(void) updateLook{
//    _lookVector = GLKVector3Make(-_attitudeMatrix.m02,
//                                 -_attitudeMatrix.m12,
//                                 -_attitudeMatrix.m22);
//    _lookAzimuth = atan2f(_lookVector.x, -_lookVector.z);
//    _lookAltitude = asinf(_lookVector.y);
}

-(void) setOrientationSensorsEnabled:(BOOL)orientationSensorsEnabled{
    _orientationSensorsEnabled = orientationSensorsEnabled;
    if(_orientationSensorsEnabled)
        [motionManager startDeviceMotionUpdates];
    else
        [motionManager stopDeviceMotionUpdates];
}

-(void) initSensors{
    motionManager = [[CMMotionManager alloc] init];
}

// part of GLKViewController
- (void)update{
    
    for(ValueAnimation *animation in _animations){
//        if([animation isMemberOfClass:[CameraAnimation class]])
//        CameraAnimation *animation = (CameraAnimation*)animation;
        
        if([[animation name] isEqualToString:@"GYRO"]){
            [geodesicView setAttitudeMatrix:[(CameraAnimation*)animation matrix]];
            [geodesicView setFieldOfView:[(CameraAnimation*)animation fieldOfView]];
            [geodesicView setCameraRadius:[(CameraAnimation*)animation radius]];
            [geodesicView setCameraRadiusFix:[(CameraAnimation*)animation radiusFix]];
            if([(CameraAnimation*)animation reverse])
                [(CameraAnimation*)animation setEndOrientation:GLKQuaternionMakeWithMatrix4([self getDeviceOrientationMatrix])];
            else
                [(CameraAnimation*)animation setStartOrientation:GLKQuaternionMakeWithMatrix4([self getDeviceOrientationMatrix])];
            
            if((CameraAnimation*)animation)
                [geodesicView setGestureRotation:GLKQuaternionMakeWithMatrix4([(CameraAnimation*)animation matrix])];
        }
        else if([[animation name] isEqualToString:@"GESTURE"]){
            gestureRotation = [(CameraAnimation*)animation quaternion];
            [geodesicView setGestureRotation:gestureRotation];
        }
        else if([[animation name] isEqualToString:@"FADE"]){
            [geodesicView setSphereAlpha:[animation value]];
            [scaleFigureView setAlpha:1.0 - (([animation value]-.5) * 2.0)];
        }
        else if([[animation name] isEqualToString:@"SLICE"]){
            [geodesicView setSlicedSphereAlpha:powf([animation value],1.5)];
        }
    }
    if(![_animations count]) {
        if(_perspective == 0){
//        orient.m32 = -5.0;
//            [geodesicView setCameraRadius:2];
            [geodesicView setGestureRotation:gestureRotation];
            [geodesicView setAttitudeMatrix:[self getDeviceOrientationMatrix]];
        }
        else if(_perspective == 1){
            
//        () FOV (0.009355): 1.876049
            [geodesicView setAttitudeMatrix:GLKMatrix4Identity];//GLKMatrix4MakeTranslation(0, 0, -52)];
//            [geodesicView setAttitudeMatrix:GLKMatrix4MakeTranslation(0, 0, -65)];
        }
        else if(_perspective == 2)
#warning todo
//TODO: make this shift around, slightly (bounded) with a translucent drawing of the triangles on the back side (cull) and a person in the middle
// or a cat
            [geodesicView setAttitudeMatrix:GLKMatrix4Identity];
//            [geodesicView setAttitudeMatrix:GLKMatrix4MakeTranslation(0, 0, -52)]; // 65
    }
}

-(void) animationHandler:(id)sender{
//    if(sender == animationPerspectiveToOrtho){
//        GLKQuaternion q = GLKQuaternionSlerp(orientation, quaternionFrontFacing, powf(frame,2));
//        _orientationMatrix = GLKMatrix4MakeWithQuaternion(q);
//        [camera dollyZoomFlat:powf(frame,3)];
//    }
//    if(sender == animationOrthoToPerspective){
//        GLKMatrix4 m = GLKMatrix4MakeLookAt(camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]), 0.0f, 0.0f, 0.0f, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
//        GLKQuaternion mtoq = GLKQuaternionMakeWithMatrix4(m);
//        GLKQuaternion q = GLKQuaternionSlerp(quaternionFrontFacing, mtoq, powf(frame,2));
//        _orientationMatrix = GLKMatrix4MakeWithQuaternion(q);
//        [camera dollyZoomFlat:powf(1-frame,3)];
//    }
}

-(GLKMatrix4) getDeviceOrientationMatrix{
    if([motionManager isDeviceMotionActive]){
        CMRotationMatrix a = [[[motionManager deviceMotion] attitude] rotationMatrix];
        // arrangements of mappings of sensor axis to virtual axis (columns)
        // and combinations of 90 degree rotations (rows)
        
//        return GLKMatrix4Make(a.m11, a.m21, a.m31, 0.0f,
//                              a.m13, a.m23, a.m33, 0.0f,
//                              -a.m12,-a.m22,-a.m32, 0.0f,
//                              0.0f , 0.0f , 0.0f , 1.0f);
        return GLKMatrix4Rotate(GLKMatrix4Make(a.m11, a.m21, a.m31, 0.0f,
                                               a.m12, a.m22, a.m32, 0.0f,
                                               a.m13, a.m23, a.m33, 0.0f,
                                               0.0f , 0.0f , 0.0f , 1.0f), M_PI*.5, 1, 0, 0);
    }
    else
        return GLKMatrix4Identity;
}

-(void) logMatrix:(GLKMatrix4)m{
    NSLog(@"\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f\n",m.m00, m.m01, m.m02, m.m10, m.m11, m.m12, m.m20, m.m21, m.m22);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
