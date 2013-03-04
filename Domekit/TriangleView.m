//
//  TriangleView.m
//  Domekit
//
//  Created by Robby on 3/3/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "TriangleView.h"

@interface TriangleView()
{
    Dome *dome;
    double scale;    // scale for rendering
    CGPoint sliceLine;
    BOOL sliceMode;
    Point3D *r;  // angle of rotation in view from normals
    NSArray *projectedPoints_;      // rotated points
    int polaris, octantis;
    BOOL sphere;  // during calculateInvisibles, updates wether a dome or a sphere
}
@end

@implementation TriangleView

-(id) init
{
    r = [[Point3D alloc] initWithCoordinatesX:0 Y:0 Z:0];
    scale = 25;
    sliceLine.y = 2;
    sliceMode = false;
    
    dome = [[Dome alloc] initWithTriangle];
    projectedPoints_ = [[NSArray alloc] initWithArray:dome.points_];
    
    //[self calculateInvisibles];
    //[self capturePoles];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return [self init];
}

-(void) generate:(int)domeV
{
    [dome geodeciseTriangle:domeV];
    
    //[self projectPoints];
    //[self capturePoles];
    //[self calculateInvisibles];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect canvas = [self bounds];
    int width = canvas.size.width;
    int height = canvas.size.height;
    int halfWidth = width/2;
    int halfHeight = height/2;
    
    //CGContextClearRect(context, [self bounds]);
    int count;
    NSNumber *connect;
    
    
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 2.0);
    

    count = 0;
    for (NSNumber *i in dome.lines_)
    {
        if (count%2==0) connect = i;
        else{
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, [dome.points_[connect.integerValue] getX]*scale+halfWidth,
                                 [dome.points_[connect.integerValue] getY]*scale+halfHeight);
            CGContextAddLineToPoint(context, [dome.points_[i.integerValue] getX]*scale+halfWidth,
                                    [dome.points_[i.integerValue] getY]*scale+halfHeight);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        count++;
    }
    
    [[UIColor blackColor] setStroke];
    [[UIColor blackColor] setFill];
    
    
    count = 0;
    for (Point3D *node in dome.points_)
    {
        CGContextFillRect(context, CGRectMake([node getX]*scale+halfWidth-2, [node getY]*scale+halfHeight-2, 4, 4));
        count++;
    }

}


@end
