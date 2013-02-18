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
    CGPoint spliceLine;
    BOOL spliceMode;
    Point3D *r;  // angle of rotation in view from normals
    NSArray *projectedPoints_;      // rotated points
    Dome *dome;
    int polaris, octantis;
}

@property Dome *dome;
@property int polaris;
@property int octantis;

-(void) capturePoles;
-(void) calculateInvisibles;
-(void) generate:(int)domeV;
-(void) refresh;
-(void) report;

-(Point3D*) getRotation;
-(void) setRotationX:(double)rX Y:(double)rY Z:(double)rZ;
-(double) getScale;
-(void) setScale:(double) s;
-(BOOL) getSpliceMode;
-(void) setSpliceMode:(BOOL) splice;
-(CGFloat) getSpliceY;
-(void) setSpliceY:(CGFloat)y;
@end
