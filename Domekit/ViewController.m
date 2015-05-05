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

// this appears to be the best way to grab orientation. if this becomes formalized, just make sure the orientations match
#define SENSOR_ORIENTATION [[UIApplication sharedApplication] statusBarOrientation] //enum  1(NORTH)  2(SOUTH)  3(EAST)  4(WEST)


@interface ViewController (){
    GeodesicView *geodesicView;
    GeodesicModel *geodesicModel;
    CMMotionManager *motionManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSensors];
    
    
    geodesicModel = [[GeodesicModel alloc] initWithFrequency:3 Solid:ICOSAHEDRON_SEED];

    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    geodesicView = [[GeodesicView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
    [self setView:geodesicView];
    
    [geodesicView setGeodesicModel:geodesicModel];    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
