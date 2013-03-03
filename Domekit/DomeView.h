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
-(double) getDomeHeight;  /* height of visible dome, between 0 and 1 */
-(double) getLongestStrutLength; /* length of longest visible strut, a fraction of the dome diameter, which is 1 */
-(int) getPointCount;  /* only visible points */
-(int) getLineCount; /* only visible lines */
-(NSArray*) getVisibleLineSpeciesCount;  /* how many of each type of strut length do we have? */
-(NSArray*) getLengthOrder;


@end
