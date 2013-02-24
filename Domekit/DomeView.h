//
//  DomeView.h
//  Domekit
//
//  Created by Robby on 1/28/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dome.h"
#import "Point3D.h"

@interface DomeView : UIView
{
    double scale;    // scale for rendering
    CGPoint sliceLine;
    BOOL sliceMode;
    Point3D *r;  // angle of rotation in view from normals
    NSArray *projectedPoints_;      // rotated points
    Dome *dome;
    int polaris, octantis;
    BOOL sphere;  // during calculateInvisibles, updates wether a dome or a sphere
}

@property Dome *dome;
@property int polaris;
@property int octantis;

-(void) capturePoles;
-(void) calculateInvisibles;
-(void) generate:(int)domeV;
-(void) refresh;
-(void) report;
-(void) align;

-(Point3D*) getRotation;
-(void) setRotationX:(double)rX Y:(double)rY Z:(double)rZ;
-(double) getScale;
-(void) setScale:(double) s;
-(BOOL) getSliceMode;
-(void) setSliceMode:(BOOL) splice;
-(CGFloat) getSliceY;
-(void) setSliceY:(CGFloat)y;
-(BOOL) isSphere;
@end
