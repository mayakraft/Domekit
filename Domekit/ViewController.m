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
#import "GeodesicModel.h"
#import "GeodesicView.h"
#import "SWRevealViewController.h"

// this appears to be the best way to grab orientation. if this becomes formalized, just make sure the orientations match
#define SENSOR_ORIENTATION [[UIApplication sharedApplication] statusBarOrientation] //enum  1(NORTH)  2(SOUTH)  3(EAST)  4(WEST)


@interface ViewController () {
    GeodesicView *geodesicView;
    GeodesicModel *geodesicModel;
    CMMotionManager *motionManager;
    UISegmentedControl *segmentedControl;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initRevealButton];
    
    [self initSensors];
    
    geodesicModel = [[GeodesicModel alloc] initWithFrequency:1 Solid:ICOSAHEDRON_SEED];

    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    geodesicView = [[GeodesicView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
    [self setView:geodesicView];
    
    [geodesicView setGeodesicModel:geodesicModel];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    [segmentedControl setFrame:CGRectMake(w*.1, h*.85, w*.8, h*.1)];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

-(void) segmentedControlChange:(UISegmentedControl*)sender{
    unsigned int frequency = [sender selectedSegmentIndex] + 1;
    [geodesicView setGeodesicModel:nil];
    [geodesicModel setFrequency:frequency];
    [geodesicView setGeodesicModel:geodesicModel];
}

-(void) initRevealButton{
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
    [geodesicView setAttitudeMatrix:[self getDeviceOrientationMatrix]];
}

-(GLKMatrix4) getDeviceOrientationMatrix{
    if([motionManager isDeviceMotionActive]){
        CMRotationMatrix a = [[[motionManager deviceMotion] attitude] rotationMatrix];
        // arrangements of mappings of sensor axis to virtual axis (columns)
        // and combinations of 90 degree rotations (rows)
        if(SENSOR_ORIENTATION == 4){
            return GLKMatrix4Make(a.m21,-a.m11, a.m31, 0.0f,
                                  a.m23,-a.m13, a.m33, 0.0f,
                                  -a.m22, a.m12,-a.m32, 0.0f,
                                  0.0f , 0.0f , 0.0f , 1.0f);
        }
        if(SENSOR_ORIENTATION == 3){
            return GLKMatrix4Make(-a.m21, a.m11, a.m31, 0.0f,
                                  -a.m23, a.m13, a.m33, 0.0f,
                                  a.m22,-a.m12,-a.m32, 0.0f,
                                  0.0f , 0.0f , 0.0f , 1.0f);
        }
        if(SENSOR_ORIENTATION == 2){
            return GLKMatrix4Make(-a.m11,-a.m21, a.m31, 0.0f,
                                  -a.m13,-a.m23, a.m33, 0.0f,
                                  a.m12, a.m22,-a.m32, 0.0f,
                                  0.0f , 0.0f , 0.0f , 1.0f);
        }
//        return GLKMatrix4Make(a.m11, a.m21, a.m31, 0.0f,
//                              a.m13, a.m23, a.m33, 0.0f,
//                              -a.m12,-a.m22,-a.m32, 0.0f,
//                              0.0f , 0.0f , 0.0f , 1.0f);
        return GLKMatrix4Make(a.m11, a.m21, a.m31, 0.0f,
                              a.m12, a.m22, a.m32, 0.0f,
                              a.m13, a.m23, a.m33, 0.0f,
                              0.0f , 0.0f , 0.0f , 1.0f);
//        return GLKMatrix4Make(a.m11*a.m11, a.m21*a.m21, a.m31*a.m31, 0.0f,
//                              a.m12*a.m12, a.m22*a.m22, a.m32*a.m32, 0.0f,
//                              a.m13*a.m13, a.m23*a.m23, a.m33*a.m33, 0.0f,
//                              0.0f , 0.0f , 0.0f , 1.0f);
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
