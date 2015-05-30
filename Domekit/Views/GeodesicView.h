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

#define FPS 60
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

@property float cameraRadius;
@property float cameraRadiusFix;

@property (nonatomic) GLKMatrix4 attitudeMatrix;
@property GLKMatrix4 projectionMatrix;

@property (nonatomic, weak) GeodesicModel *geodesicModel;

@property BOOL sphereOverride;

@end
