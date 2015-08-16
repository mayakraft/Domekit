//
//  RotationGestureRecognizer.m
//  Domekit
//
//  Created by Robby on 8/9/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "RotationGestureRecognizer.h"

#define SCALE .00011

@implementation RotationGestureRecognizer

-(GLKQuaternion)rotationInView:(UIView *)view{
    CGPoint t = [self velocityInView:view];
    GLKQuaternion q = GLKQuaternionIdentity;
    float a = sqrt((t.x * t.x) + (t.y * t.y));
    t.x /= a;
    t.y /= a;
    
    float angle = atan2(t.x, t.y);
    
    return GLKQuaternionMakeWithAngleAndAxis(a * SCALE, cos(angle), sin(angle), 0);
//    NSLog(@"(%.2f : %.2f)",t.y, t.x);
    return GLKQuaternionNormalize(GLKQuaternionMake(t.y * SCALE, t.x * SCALE, 0, 1.0 - (t.y * .5 * SCALE + t.x * .5 * SCALE) ));

    
//    return GLKQuaternionMakeWithAngleAndAxis(.01, t.y, t.x, 0);
//    t.x *= SCALE;
//    t.y *= SCALE;
//    q.w = 1.0 * t.x;
//    q.x = ;
//    q.y = 1.0 * t.y;
//    q.z *= ;
    return q;
}

@end
