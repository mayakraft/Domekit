//
//  ViewController.m
//  Domekit
//
//  Created by Robby on 5/3/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import <CoreMotion/CoreMotion.h>

// CONTROLLERS
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
#import "ValueAnimation.h"
// GESTURES
#import "RotationGestureRecognizer.h"

#define NAVBAR_HEIGHT 88
#define EXT_NAVBAR_HEIGHT 57

#define ORTHO_ANIM_TIME 0.266f

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

@property (weak) UISegmentedControl *topMenu;
@property (nonatomic) NSUInteger perspective;  // basically, a persistent topMenu selectedIndex
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

    // for logarithmic purposes, 1 bigger than 10
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

    
    // NAVIGATION BAR
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
    float gestureTop = extendedNavBar.frame.origin.y + extendedNavBar.frame.size.height;
    float gestureHeight = controllerFrame.origin.y - gestureTop;
    UIView *gestureView = [[UIView alloc] initWithFrame:CGRectMake(0, gestureTop, [[UIScreen mainScreen] bounds].size.width, gestureHeight)];
    [self.view addSubview:gestureView];
    [gestureView addGestureRecognizer:touchRotationGesture];
    
    [self setPerspective:0];
    [self.view bringSubviewToFront:extendedNavBar];
//    NSLog(@"SAVED DOMES: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"saved"]);
}

#pragma mark- ANIMATION DELEGATES
-(void) valueAnimationDidUpdate:(ValueAnimation *)sender{
//    if([[sender name] isEqualToString:@"GYRO"]){ }
//    else if([[sender name] isEqualToString:@"GESTURE"]){ }
}
-(void) valueAnimationDidStop:(ValueAnimation *)sender{
    if([[sender name] isEqualToString:@"GYRO"]){ }
    else if([[sender name] isEqualToString:@"GESTURE"]){
        // animate a change in the rotation due to gesture
        gestureRotation = [(CameraAnimation*)sender quaternion]; //GLKQuaternionIdentity;
        [geodesicView setGestureRotation:gestureRotation];
    }
    else if([[sender name] isEqualToString:@"FADE"]){
        // fade opacity of entire dome by half, to superimpose scale figure on top
        [geodesicView setSphereAlpha:[sender value]];
        [scaleFigureView setAlpha:1.0 - (([sender value]-.5) * 2.0)];
    }
    else if ([[sender name] isEqualToString:@"SLICE"]){
        // fade in/out sliced off part of sphere
        [geodesicView setSlicedSphereAlpha:[sender value]];
    }
    
//    [geodesicView setCameraRadius:[geodesicView cameraRadius]];

    // MUST BE AT END
    // remove animation and dealloc it
    NSMutableArray *anim = [_animations mutableCopy];
    [anim removeObject:sender];
    _animations = anim;
    sender = nil;
}

#pragma mark- USER INTERFACE HANDLERS

// called every frame. part of GLKViewController
- (void)update{
    
    for(ValueAnimation *animation in _animations){
//        if([animation isMemberOfClass:[CameraAnimation class]])
//        CameraAnimation *animation = (CameraAnimation*)animation;
        if([[animation name] isEqualToString:@"GYRO"]){
            // animate away rotation due to gryo
            // and animate dolly zoom
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
            // animate rotation due to gesture panning
            gestureRotation = [(CameraAnimation*)animation quaternion];
            [geodesicView setGestureRotation:gestureRotation];
        }
        else if([[animation name] isEqualToString:@"FADE"]){
            // fade opacity of entire dome by half, to superimpose scale figure on top
            [geodesicView setSphereAlpha:[animation value]];
            [scaleFigureView setAlpha:1.0 - (([animation value]-.5) * 2.0)];
        }
        else if([[animation name] isEqualToString:@"SLICE"]){
            // fade in/out sliced off part of sphere
            [geodesicView setSlicedSphereAlpha:powf([animation value],1.5)];
        }
    }
    if(![_animations count]) {
        // if no animations are happening, update the change in rotations as you were
        if(_perspective == 0){
            [geodesicView setGestureRotation:gestureRotation];
            [geodesicView setAttitudeMatrix:[self getDeviceOrientationMatrix]];
        }
        else if(_perspective == 1){
            [geodesicView setAttitudeMatrix:GLKMatrix4Identity];//GLKMatrix4MakeTranslation(0, 0, -52)];
        }
        else if(_perspective == 2)
            // tried once,didn't work so well, maybe try this again sometime
            // make this shift around, slightly (bounded) with a translucent drawing of the triangles on the back side (cull) and a person in the middle
            [geodesicView setAttitudeMatrix:GLKMatrix4Identity];
    }
}
-(void) rotationGestureHandler:(RotationGestureRecognizer*)sender{
    static GLKQuaternion start, cumulative;
    static GLKQuaternion operatingFrame;
    
    if([sender state] == 1){
        // in case gyro is on, store the present rotation context before we apply gesture rotations
        operatingFrame = GLKQuaternionMakeWithMatrix4([self getDeviceOrientationMatrix]);
        // before gesture starts, store previous motion
        start = gestureRotation;
        cumulative = GLKQuaternionIdentity;
    }
    if([sender state] == 2){
        if([sender lockToY]){
            // disregard all gyroscope reference frames in this special case
            cumulative = GLKQuaternionMultiply(cumulative, [sender rotationInView:geodesicView]);
            gestureRotation = GLKQuaternionMultiply(cumulative, start);
            [geodesicView setGestureRotation:gestureRotation];
        }
        else{
            // the theory here goes:
            // the rotation due to guesture is a tiny quaternion, apply it to the context of the operating frame, due to the gyroscope
            GLKQuaternion q = GLKQuaternionMultiply([sender rotationInView:geodesicView], operatingFrame);
            // then divide out from under it the operating frame (multiply the inverse)
            q = GLKQuaternionMultiply(GLKQuaternionInvert(operatingFrame), q);
            // and somehow it preserves the gesture rotation in the operating frame.
            // i'm not really even sure how this works, but it does
            cumulative = GLKQuaternionMultiply(cumulative, q);//[sender rotationInView:geodesicView]);
            gestureRotation = GLKQuaternionMultiply(cumulative, start);
            [geodesicView setGestureRotation:gestureRotation];
        }
    }
}

-(void) topMenuChange:(UISegmentedControl*)sender{
    // do this anytime you might be adding animations to the animation array
    if(!_animations)
        _animations = @[];
    
    // CAMERA ANIMATIONS
    // begins now with duration set by ORTHO_ANIM_TIME
    if(_perspective == 0 && [sender selectedSegmentIndex] != 0){
        // from full freedom of rotation to restricted
        // gyro to identity
        CameraAnimation *gyroOrientationAnimation = [[CameraAnimation alloc] initWithName:@"GYRO" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0 EndValue:0];
        [gyroOrientationAnimation setStartOrientation:GLKQuaternionMakeWithMatrix4([self getDeviceOrientationMatrix])];
        [gyroOrientationAnimation setEndOrientation:GLKQuaternionIdentity];
        _animations = [_animations arrayByAddingObject:gyroOrientationAnimation];

        // gesture to near identity, still allow movement around Y
        CameraAnimation *gestureOrientationAnimation = [[CameraAnimation alloc] initWithName:@"GESTURE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0 EndValue:0];
        [gestureOrientationAnimation setStartOrientation:gestureRotation];
        [gestureOrientationAnimation setEndOrientation:GLKQuaternionNormalize(GLKQuaternionMake(0, gestureRotation.y, 0, gestureRotation.w))];
        _animations = [_animations arrayByAddingObject:gestureOrientationAnimation];
        
        // animate fade-out sliced part of dome
        ValueAnimation *sliceAnimation = [[ValueAnimation alloc] initWithName:@"SLICE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:1.0 EndValue:0.0];
        _animations = [_animations arrayByAddingObject:sliceAnimation];
    }
    if(_perspective != 0 && [sender selectedSegmentIndex] == 0){
        // from restricted freedom of rotation back to freedom on all axes
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

        // animate fade-in sliced part of dome
        ValueAnimation *sliceAnimation = [[ValueAnimation alloc] initWithName:@"SLICE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:0.0 EndValue:1.0];
        _animations = [_animations arrayByAddingObject:sliceAnimation];
    }
    if(_perspective != 2 && [sender selectedSegmentIndex] == 2){
        // fade entire dome to allow superimposed scale figure
        ValueAnimation *fadeAnimation = [[ValueAnimation alloc] initWithName:@"FADE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:1.0 EndValue:.5];
        _animations = [_animations arrayByAddingObject:fadeAnimation];
    }
    if(_perspective == 2 && [sender selectedSegmentIndex] != 2){
        // fade back in dome when removing scale figure
        ValueAnimation *fadeAnimation = [[ValueAnimation alloc] initWithName:@"FADE" Duration:ORTHO_ANIM_TIME FramesPerSecond:FPS Delegate:self StartValue:.5 EndValue:1.0];
        _animations = [_animations arrayByAddingObject:fadeAnimation];
    }
    // SHOW / HIDE PARTS OF UI
    if([sender selectedSegmentIndex] == 0){
        [frequencyControlView setHidden:NO];
        [sliceControlView setHidden:YES];
        [scaleControlView setHidden:YES];
        [geodesicView setSphereOverride:YES];
        [touchRotationGesture setLockToY:NO];
    }
    else if([sender selectedSegmentIndex] == 1){
        [frequencyControlView setHidden:YES];
        [sliceControlView setHidden:NO];
        [scaleControlView setHidden:YES];
        [geodesicView setSphereOverride:NO];
        [touchRotationGesture setLockToY:YES];
    }
    else if([sender selectedSegmentIndex] == 2){
        [frequencyControlView setHidden:YES];
        [sliceControlView setHidden:YES];
        [scaleControlView setHidden:NO];
        [geodesicView setSphereOverride:NO];
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
    // reset sliced dome back to sphere on frequency change
    [[sliceControlView slider] setValue:1.0];  // optional method would be to search for a closest fit here
    [geodesicModel setFrequency:frequency];
    [self updateUI];
//    [geodesicView setGeodesicModel:geodesicModel];
    [geodesicView setNeedsDisplay];
}
-(void) sliceControlChange:(UISlider*)sender{
// prevent calling on every little pixel of a change in the UISlider
    static int lastUnit = -1;
    int unit = sender.value * ([geodesicModel frequencyDenominator] - 1);
    if(unit == lastUnit)
        return;
    lastUnit = unit;

    if(unit+1 >= [geodesicModel frequencyDenominator]){
        // numerator must be smaller than or equal to denominator
        [geodesicModel setSphere];
        [self updateUI];
        return;
    }
    [geodesicModel setFrequencyNumerator:unit+1];
    [self updateUI];
}
-(void) scaleControlChange:(UISlider*)sender{
    // the value preserved from last time
    static float baseScale;
    // sensitivity in the affected change to scale
    float SENSITIVITY = 0.3f;
    if([sender state] == 0)  // touches begin
        baseScale = _sessionScale;
    else{
        // .5 is HOME, okay this is some hacky stuff
        _sessionScale = baseScale * pow(baseScale,(sender.value - .5) * SENSITIVITY);
    }
    if(_sessionScale > 1000000.0)
        _sessionScale = 1000000.0;
    [self updateUI];
}
-(void) scaleControlChangeEnd:(UISlider*)sender{
    // animate scale slider back to HOME (center of slider)
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
    [self updateUI];
}
-(void) newPolyhedra:(unsigned int)solidType{
    _solidType = solidType;
    // all kinds of stuff across the app gets reset here
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
    [scaleFigureView setAlpha:0.0];
    [geodesicView setSphereOverride:YES];
    [touchRotationGesture setLockToY:NO];
    [[sliceControlView slider] setValue:1.0];
    [[frequencyControlView segmentedControl] setSelectedSegmentIndex:0];
    [self updateUI];
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
    [[NSUserDefaults standardUserDefaults] setObject:saved forKey:@"saved"];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateUserPreferencesAcrossApp];
}
-(void) loadDome:(NSDictionary *)dome{
    // prevent loading corrupted data
    if(!([dome objectForKey:@"frequency"] && [dome objectForKey:@"solid"] && [dome objectForKey:@"numerator"] && [dome objectForKey:@"denominator"] && [dome objectForKey:@"scale"])){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Loading Error" message:[NSString stringWithFormat:@"This saved dome appears to be corrupted, and should be re-made and re-saved"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okayButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
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
#pragma mark- VIEW CONTROLLERS AND IOS STUFF

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

-(void) updateUI{
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
    // update scale view with new values and units
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
-(void) initRevealController{
    SWRevealViewController *revealController = self.revealViewController;
    //    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    // Pan swiping to reveal the menu
    //    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIButton *revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22*3/2, 17*3/2)];
    [revealButton setBackgroundImage:[UIImage imageNamed:@"reveal-icon"] forState:UIControlStateNormal];
    [revealButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *revealBarButton = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
    [self.navigationItem setLeftBarButtonItem:revealBarButton];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- ORIENTATION SENSORS

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

@end
