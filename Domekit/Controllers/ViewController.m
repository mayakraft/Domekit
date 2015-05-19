//
//  ViewController.m
//  Domekit
//
//  Created by Robby on 5/3/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import <CoreMotion/CoreMotion.h>

#import "ViewController.h"

#import "DiagramViewController.h"

// NAVIGATION BAR
#import "SWRevealViewController.h"
#import "ExtendedNavBarView.h"
// VIEWS
#import "GeodesicView.h"
#import "FrequencyControlView.h"
#import "SliceControlView.h"
#import "ScaleControlView.h"
// DATA MODELS
#import "GeodesicModel.h"
#import "Animation.h"


// this appears to be the best way to grab orientation. if this becomes formalized, just make sure the orientations match
#define DEVICE_ORIENTATION [[UIApplication sharedApplication] statusBarOrientation] //enum  1(NORTH)  2(SOUTH)  3(EAST)  4(WEST)


#define NAVBAR_HEIGHT 88
#define EXT_NAVBAR_HEIGHT 57

@interface ViewController () {
    GeodesicView *geodesicView;
    GeodesicModel *geodesicModel;
    CMMotionManager *motionManager;
    Animation *projectionAnimation;
    
    // Bottom screen controls
    FrequencyControlView *frequencyControlView;
    SliceControlView *sliceControlView;
    ScaleControlView *scaleControlView;

//    PolyhedronSeed seedType;
    
}

@property (nonatomic) NSUInteger perspective;
@end

@implementation ViewController

-(id) initWithPolyhedra:(unsigned int)solidType{
    self = [super init];
    if(self){
//        seedType = solidType;
        _solidType = solidType;
        geodesicModel = [[GeodesicModel alloc] initWithFrequency:1 Solid:_solidType];
    }
    return self;
}

-(id) init{
    self = [super init];
    if(self){
        geodesicModel = [[GeodesicModel alloc] initWithFrequency:1 Solid:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initRevealController];
    
    [self initSensors];
    
//    if(seedType == 0)
//        [self setTitle:@"1V ICO SPHERE"];
//    if(seedType == 1)
//        [self setTitle:@"1V OCTA SPHERE"];

    [self updateTitle];

    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    
    
    geodesicView = [[GeodesicView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
    [self setView:geodesicView];
    
    [geodesicView setGeodesicModel:geodesicModel];

    
    // For the extended navigation bar effect to work, a few changes
    // must be made to the actual navigation bar.  Some of these changes could
    // be applied in the storyboard but are made in code for clarity.
    
    // Translucency of the navigation bar is disabled so that it matches with
    // the non-translucent background of the extension view.
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // The navigation bar's shadowImage is set to a transparent image.  In
    // conjunction with providing a custom background image, this removes
    // the grey hairline at the bottom of the navigation bar.  The
    // ExtendedNavBarView will draw its own hairline.
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    // "Pixel" is a solid white 1x1 image.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *makeButton = [[UIBarButtonItem alloc] initWithTitle:@"Make" style:UIBarButtonItemStylePlain target:self action:@selector(makeDiagram)];
    self.navigationItem.rightBarButtonItem = makeButton;
    
    ExtendedNavBarView *extendedNavBar = [[ExtendedNavBarView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, EXT_NAVBAR_HEIGHT)];
    extendedNavBar.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Frequency", @"Slice", @"Scale"]];

    [[extendedNavBar segmentedControl] addTarget:self action:@selector(topMenuChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:extendedNavBar];

    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height - NAVBAR_HEIGHT;
    CGRect controllerFrame = CGRectMake(0, h*.75 + NAVBAR_HEIGHT * .5, w, h*.25);
    frequencyControlView = [[FrequencyControlView alloc] initWithFrame:controllerFrame];
    [self.view addSubview:frequencyControlView];
    [[frequencyControlView segmentedControl] addTarget:self action:@selector(frequencyControlChange:) forControlEvents:UIControlEventValueChanged];
    
    sliceControlView = [[SliceControlView alloc] initWithFrame:controllerFrame];
    [self.view addSubview:sliceControlView];
    [[sliceControlView slider] addTarget:self action:@selector(sliceControlChange:) forControlEvents:UIControlEventValueChanged];

    scaleControlView = [[ScaleControlView alloc] initWithFrame:controllerFrame];
    [self.view addSubview:scaleControlView];
    [[scaleControlView slider] addTarget:self action:@selector(scaleControlChange:) forControlEvents:UIControlEventValueChanged];
    
    [sliceControlView setHidden:YES];
    [scaleControlView setHidden:YES];
}
-(void) makeDiagram{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.55];
    DiagramViewController *dVC = [[DiagramViewController alloc] init];
    [geodesicModel makeLineClasses];
    [dVC setGeodesicModel:geodesicModel];
    
    [self.navigationController pushViewController:dVC animated:YES];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];

}
-(void) topMenuChange:(UISegmentedControl*)sender{
    [self setPerspective:[sender selectedSegmentIndex]];
    if([sender selectedSegmentIndex] == 0){
        [frequencyControlView setHidden:NO];
        [sliceControlView setHidden:YES];
        [scaleControlView setHidden:YES];
        [geodesicView setShowMeridians:NO];
    }
    else if([sender selectedSegmentIndex] == 1){
        [frequencyControlView setHidden:YES];
        [sliceControlView setHidden:NO];
        [scaleControlView setHidden:YES];
        [geodesicView setShowMeridians:YES];
    }
    else if([sender selectedSegmentIndex] == 2){
        [frequencyControlView setHidden:YES];
        [sliceControlView setHidden:YES];
        [scaleControlView setHidden:NO];
        [geodesicView setShowMeridians:NO];
    }
}
-(void) setPerspective:(NSUInteger)perspective{
    _perspective = perspective;
    if(_perspective == 0)
        [geodesicView setFieldOfView:45 + 45 * atanf(geodesicView.aspectRatio)];
    if(_perspective == 1)
        [geodesicView setFieldOfView:20];
    if(_perspective == 2)
        [geodesicView setFieldOfView:45 + 45 * atanf(geodesicView.aspectRatio)];
}
-(void) updateTitle{
    if(_solidType == 0)
        [self setTitle:[NSString stringWithFormat:@"%dV ICO SPHERE",[geodesicModel frequency] ]];
    if(_solidType == 1)
        [self setTitle:[NSString stringWithFormat:@"%dV OCTA SPHERE",[geodesicModel frequency] ]];
}
-(void) setSolidType:(unsigned int)solidType{
    _solidType = solidType;
    [geodesicModel setSolid:solidType];
    NSLog(@"SLICERS: %@",[geodesicModel slicePoints]);
    [self updateTitle];
}
-(void) frequencyControlChange:(UISegmentedControl*)sender{
    unsigned int frequency = (unsigned int)([sender selectedSegmentIndex] + 1);
//    [geodesicView setGeodesicModel:nil];
    [geodesicModel setFrequency:frequency];
    NSLog(@"SLICERS: %@",[geodesicModel slicePoints]);
    [self updateTitle];
//    [geodesicView setGeodesicModel:geodesicModel];
}
-(void) sliceControlChange:(UISlider*)sender{
    [geodesicView setSliceAmount:sender.value];
}
-(void) scaleControlChange:(UISlider*)sender{
    
}
-(void) initRevealController{
    SWRevealViewController *revealController = self.revealViewController;
//    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    //TODO: this is not dynamically sized
    UIButton *revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22*3/2, 17*3/2)];
    [revealButton setBackgroundImage:[UIImage imageNamed:@"reveal-icon"] forState:UIControlStateNormal];
    [revealButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *revealBarButton = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
    [self.navigationItem setLeftBarButtonItem:revealBarButton];
}

-(void) updateLook{
//    _lookVector = GLKVector3Make(-_attitudeMatrix.m02,
//                                 -_attitudeMatrix.m12,
//                                 -_attitudeMatrix.m22);
//    _lookAzimuth = atan2f(_lookVector.x, -_lookVector.z);
//    _lookAltitude = asinf(_lookVector.y);
}

-(void) initSensors{
    motionManager = [[CMMotionManager alloc] init];
    [motionManager startDeviceMotionUpdates];
}

// part of GLKViewController
- (void)update{
    GLKMatrix4 orient = [self getDeviceOrientationMatrix];
//    orient.m32 = -5.0;
    if(_perspective == 0)
        [geodesicView setAttitudeMatrix:orient];
    if(_perspective == 1)
        [geodesicView setAttitudeMatrix:GLKMatrix4MakeTranslation(0, 0, -5)];
    if(_perspective == 2)
        [geodesicView setAttitudeMatrix:orient];
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
        return GLKMatrix4Make(a.m11, a.m21, a.m31, 0.0f,
                              a.m12, a.m22, a.m32, 0.0f,
                              a.m13, a.m23, a.m33, 0.0f,
                              0.0f , 0.0f , 0.0f , 1.0f);
//        return GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f,
//                              0.0f, 1.0f, 0.0f, 0.0f,
//                              0.0f, 0.0f, 1.0f, 0.0f,
//                              0.0f , 0.0f , -5.0f , 1.0f);
    }
    else
//        return GLKMatrix4Identity;
        return GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f,
                              0.0f, 1.0f, 0.0f, 0.0f,
                              0.0f, 0.0f, 1.0f, 0.0f,
                              0.0f, 0.0f, 0.0f, 1.0f);

}

-(void) logMatrix:(GLKMatrix4)m{
    NSLog(@"\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f\n",m.m00, m.m01, m.m02, m.m10, m.m11, m.m12, m.m20, m.m21, m.m22);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
