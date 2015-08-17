//
//  RotationGestureRecognizer.h
//  Domekit
//
//  Created by Robby on 8/9/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface RotationGestureRecognizer : UIPanGestureRecognizer

-(GLKQuaternion) rotationInView:(UIView*)view;

@property BOOL lockToY;

@end
