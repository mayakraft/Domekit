//
//  Instructions.m
//  Domekit
//
//  Created by Robby on 3/6/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "Instructions.h"
#import "QuartzCore/QuartzCore.h"
#import "Dome.h"

@interface Instructions ()
{
    Dome *dome;
    double size;    // scale for rendering
    int polaris, octantis;
    CGFloat lineWidth;
    NSArray *colorTable;
    UIImage *instructionsImage;
}

@end

@implementation Instructions

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"Don't init this way");
    self = [super initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame withDome:(Dome*)domeImport
{
    self = [super initWithFrame:frame];
    if (self) {
        lineWidth = 1;
        size = 28;
        dome = [[Dome alloc] initWithDome:domeImport];
        [self alignPoles];
    }
    colorTable = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0],  //red
                  [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0],  //blue
                  [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0],  //green
                  [UIColor colorWithRed:0.53 green:0 blue:0.8 alpha:1.0],  //purple
                  [UIColor colorWithRed:1 green:0.66 blue:0 alpha:1.0],   //orange
                  [UIColor colorWithRed:0 green:0.66 blue:0.66 alpha:1.0], //teal
                  [UIColor colorWithRed:0.88 green:0.88 blue:0 alpha:1.0],  //gold
                  [UIColor colorWithRed:0.86 green:0 blue:0.73 alpha:1.0],  //pink
                  [UIColor colorWithRed:0.66 green:.88 blue:0 alpha:1.0],  // lime green
                  [UIColor colorWithRed:0.62 green:.42 blue:0.27 alpha:1.0],  // brown
                  [UIColor colorWithRed:0.6 green:0.725 blue:0.95 alpha:1.0],  // light blue
                  [UIColor colorWithRed:1 green:0.81 blue:0.51 alpha:1.0],  // salmon
                  [UIColor colorWithRed:.89 green:0.6 blue:0.97 alpha:1.0],  // light purple
                  [UIColor colorWithRed:.5 green:1 blue:1 alpha:1.0],  // cyan
                  [UIColor colorWithRed:.75 green:.75 blue:.15 alpha:1.0],  // dull yellow
                  [UIColor colorWithRed:0 green:.63 blue:.42 alpha:1.0],  // sea green
                  [UIColor colorWithRed:0.26 green:0.19 blue:0.73 alpha:1.0],  // purple-blue
                  [UIColor colorWithRed:0.2 green:0.47 blue:0.16 alpha:1.0],  // forest green
                  [UIColor colorWithRed:0.19 green:0.37 blue:0.52 alpha:1.0],  // gray blue
                  [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0], nil];  //gray
    
    return self;
}
-(void) setScale:(double)x { size = x; }
-(void) setLineWidth:(CGFloat)x { lineWidth = x; }

// calling this before drawing diagram centers the top point (polaris) in the middle of the diagram
-(void) alignPoles
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    Point3D *rotated = [[Point3D alloc] init];
    double offset =  atan2([dome.points_[octantis] getX], [dome.points_[octantis] getY]);
    double distance, angle;
    for(int i = 0; i < dome.points_.count; i++)
    {
        angle = atan2([dome.points_[i] getX], [dome.points_[i] getY]);
        distance = sqrt( pow([dome.points_[i] getX], 2) + pow([dome.points_[i] getY], 2) );
        rotated = [[Point3D alloc] initWithCoordinatesX:distance*sin(angle-offset)
                                                      Y:distance*cos(angle-offset)
                                                      Z:[dome.points_[i] getZ]];
        [points addObject:rotated];
    }
    dome.points_ = [[NSArray alloc] initWithArray:points];
    points = [[NSMutableArray alloc] init];
    offset =  atan2([dome.points_[octantis] getZ], [dome.points_[octantis] getY]);
    for(int i = 0; i < dome.points_.count; i++)
    {
        angle = atan2([dome.points_[i] getZ], [dome.points_[i] getY]);
        distance = sqrt( pow([dome.points_[i] getZ], 2) + pow([dome.points_[i] getY], 2) );
        rotated = [[Point3D alloc] initWithCoordinatesX:[dome.points_[i] getX]
                                                      Y:distance*cos(angle-offset)
                                                      Z:distance*sin(angle-offset)];
        [points addObject:rotated];
    }
    dome.points_ = [[NSArray alloc] initWithArray:points];
}

-(NSArray*) getLengthOrder
{
    NSMutableArray *lengthOrder = [[NSMutableArray alloc] initWithCapacity:dome.lineClassLengths_.count];
    int i, j, index;
    for(i = 0; i < dome.lineClassLengths_.count; i++) [lengthOrder addObject:[[NSNumber alloc] initWithInt:0]];
    for(i = 0; i < dome.lineClassLengths_.count; i++){
        index = 0;
        for(j = 0; j < dome.lineClassLengths_.count; j++){
            if(i!=j && [dome.lineClassLengths_[i] doubleValue] > [dome.lineClassLengths_[j] doubleValue]) index++;
        }
        lengthOrder[index] = [[NSNumber alloc] initWithInt:i];
    }
    return [[NSArray alloc] initWithArray:lengthOrder];
}

// draws an assembly diagram with a size and line width as specified in setScale and setLineWidth
- (void)drawRect:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    instructionsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGContextRef context = UIGraphicsGetCurrentContext();
    int halfHeight = [self bounds].size.height / 2.0;
    int halfWidth = [self bounds].size.width / 2.0;
    Point3D *point1 = [[Point3D alloc] init];
    Point3D *point2 = [[Point3D alloc] init];
    int count, countByOne;
    double angle, yOffset, scale;
    double lowest = 0;
    double fisheye; /* close-to-sphere domes are further extended at their edges to prevent overlapping lines */
  
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGFloat dashedLine[2] = {0.5,1.5};
    
    //NSArray *lengthOrder = [[NSArray alloc] initWithArray:[self getLengthOrder]];
    
    for(count = 0; count < dome.points_.count; count++)
    {
        if( count != octantis &&[dome.invisiblePoints_[count] boolValue] == FALSE)
        {
            yOffset = asin([dome.points_[count] getY]/1.9022) / (M_PI/2) + 1;
            if(yOffset > lowest) lowest = yOffset;
        }
    }
    if([dome.invisiblePoints_[octantis] boolValue] == TRUE)
    {
        if(lowest > 1.63) scale = size/(lowest*1.25);
        else scale = size/(lowest);
    }
    else scale = size/(2.5);
    
    [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    int index1, index2;
    countByOne = 0;
    for(count = 0; count < dome.lines_.count; count+=2)
    {
        //if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] < colorTable.count-1)
        //    [(UIColor*)colorTable[[lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue]] setStroke];
        if( [ dome.lineClass_[countByOne] integerValue] < colorTable.count-1)
            [(UIColor*)colorTable[ [dome.lineClass_[countByOne] integerValue]] setStroke];
        else
            [(UIColor*)colorTable[colorTable.count-1] setStroke];
        
        if( [dome.invisibleLines_[count] boolValue] == FALSE)
        {
            index1 = [dome.lines_[count] integerValue];
            index2 = [dome.lines_[count+1] integerValue];
            if(index1 != octantis && index2 != octantis)
            {
                point1 = dome.points_[index1];
                point2 = dome.points_[index2];
                
                angle = atan2([point1 getZ],
                              [point1 getX]);
                yOffset = asin([point1 getY]/1.9022) / (M_PI/2) + 1;
                
                if(yOffset > 1.63) fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
                else fisheye = 1;
                
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                     fisheye*yOffset*cos(angle)*scale+halfHeight);
                angle = atan2([point2 getZ],
                              [point2 getX]);
                yOffset = asin([point2 getY]/1.9022) / (M_PI/2) + 1;
                
                if(yOffset > 1.63) fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
                else fisheye = 1;
                
                CGContextAddLineToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                        fisheye*yOffset*cos(angle)*scale+halfHeight);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
            else
            {
                point1 = dome.points_[index1];
                point2 = dome.points_[index2];
                if (index1 == octantis)
                {
                    angle = atan2([point2 getZ],
                                  [point2 getX]);
                    yOffset = asin([point2 getY]/1.9022) / (M_PI/2) + 1;
                    if(yOffset > 1.63) fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
                    else fisheye = 1;
                }
                else if(index2 == octantis)
                {
                    angle = atan2([point1 getZ],
                                  [point1 getX]);
                    yOffset = asin([point1 getY]/1.9022) / (M_PI/2) + 1;
                    if(yOffset > 1.63) fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
                    else fisheye = 1;
                }
                CGContextBeginPath(context);
                CGContextSetLineDash(context, 0.0f, dashedLine, 2);
                CGContextSetLineCap(context, kCGLineCapButt);
                CGContextMoveToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                     fisheye*yOffset*cos(angle)*scale+halfHeight);
                CGContextAddLineToPoint(context, fisheye*2*sin(angle)*scale+halfWidth,
                                        fisheye*2*cos(angle)*scale+halfHeight);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
                CGContextSetLineDash(context, 0, NULL, 0);
                CGContextSetLineCap(context, kCGLineCapRound);
            }
        }
        countByOne++;
    }    

    UIGraphicsEndImageContext();
    instructionsImage = UIGraphicsGetImageFromCurrentImageContext();

}

@end
