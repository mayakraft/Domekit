//
//  DiagramView.h
//  Domekit
//
//  Created by Robby on 2/4/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dome.h"

@interface DiagramView : UIView
{
    Dome *dome;
    double size;    // scale for rendering
    int polaris, octantis;
    CGFloat lineWidth;
    UIImage *imageForContext;
}

@property Dome *dome;

-(id) initWithFrame:(CGRect)frame Dome:(Dome*)domeIn;
-(void) importDome:(Dome*)domeIn Polaris:(int)north Octantis:(int)south;
-(void) alignPoles;
-(void) setScale:(double)x;
-(void) setLineWidth:(CGFloat)x;
-(int) getLineCount;
-(int) getPointCount;
-(double) getDomeHeight;  /* returns value between 0 and 1 */
-(NSArray*) getLengthOrder;

-(NSArray*) getVisibleLineSpeciesCount;

-(UIImage*)getImage;

@end
