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
	// sometimes velocityInView will return nan
	if(isnan(t.x)){ t.x = 0; }
	if(isnan(t.y)){ t.y = 0; }
    float a = sqrt((t.x * t.x) + (t.y * t.y));
    t.x /= a;
    t.y /= a;
    float angle = atan2(t.x, t.y);
    if(_lockToY)
        return GLKQuaternionMakeWithAngleAndAxis(a * SCALE, 0, sin(angle), 0);
    else
        return GLKQuaternionMakeWithAngleAndAxis(a * SCALE, cos(angle), sin(angle), 0);
}

@end
