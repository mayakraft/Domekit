//
//  View.h
//  Domekit
//
//  Created by Robby on 5/4/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <OpenGLES/ES1/gl.h>
#import "GeodesicModel.h"

#define FPS 30
#define FOV_MIN 1
#define FOV_MAX 155
#define Z_NEAR 0.1f
#define Z_FAR 100.0f

typedef enum{
    POLAR,  FPP,  ORTHO
} perspective_t;

@interface GeodesicView : GLKView

@property float aspectRatio;
@property (nonatomic) float fieldOfView;

@property (nonatomic) float sphereAlpha;   // visible triangles, default: 1.0
@property float slicedSphereAlpha;  // sliced-off part of sphere, for animating fade in/out


@property BOOL sphereOverride;


@property float cameraRadius;
@property float cameraRadiusFix;

@property (nonatomic) GLKQuaternion gestureRotation;

@property (nonatomic) GLKMatrix4 attitudeMatrix;
@property GLKMatrix4 projectionMatrix;

@property (nonatomic, weak) GeodesicModel *geodesicModel;

@property float yOffset; // using y translation to fix for iPhone X

@end
