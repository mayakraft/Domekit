//
//  DiagramView.m
//  Domekit
//
//  Created by Robby on 2/4/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "DiagramView.h"

@interface DiagramView()
{
    Dome *dome;
    double size;    // scale for rendering
    int polaris, octantis;
    CGFloat lineWidth;
    UIImage *imageForContext;
}
@end

@implementation DiagramView

@synthesize dome;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"Don't init this way");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame Dome:(Dome*)domeIn
{
    self = [super initWithFrame:frame];
    if (self) {
        lineWidth = 1;
        size = 33;
        dome = [[Dome alloc] initWithDome:domeIn];
        [self alignPoles];
    }
    return self;
}

-(double) getDomeHeight  /* returns value between 0 and 1 */
{
    double lowest = -2;
    double max = sqrt( ((1 + sqrt(5)) / 2 ) + 2 );
    for(int i = 0; i < dome.points_.count; i++)
    {
        if([dome.invisiblePoints_[i] boolValue] == FALSE && [dome.points_[i] getY] > lowest)
            lowest = [dome.points_[i] getY];
    }
    lowest = ( lowest + max ) / (2 * max);
    if(lowest < 0) lowest = 0;
    return lowest;
}

-(int) getLineCount /* only visible lines */
{
    int count = 0;
    for(int i = 0; i < dome.invisibleLines_.count; i++)
    {
        if([dome.invisibleLines_[i] boolValue] == FALSE) count++;
    }
    count = count/2.0;  // lines are stored as pairs of points, so divide by 2
    return count;
}

-(int) getPointCount  /* only visible points */
{
    int count = 0;
    for(int i = 0; i < dome.invisiblePoints_.count; i++)
    {
        if([dome.invisiblePoints_[i] boolValue] == FALSE) count++;
    }
    return count;
}

-(NSArray*) getVisibleLineSpeciesCount  /* how many of each type of strut length do we have? */
{
    int i;
    int speciesCount[dome.lineClass_.count];
    for(i = 0; i < dome.lineClass_.count; i++) speciesCount[i] = 0;
    for(i = 0; i < dome.lineClass_.count; i++)
    {
        if(![dome.invisibleLines_[i*2] boolValue])speciesCount[[dome.lineClass_[i] integerValue]]++;
    }
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    for(i = 0; i < dome.lineClass_.count; i++)
    {
        if(speciesCount[i] != 0) mutable[i] = [[NSNumber alloc] initWithInt:speciesCount[i]];
    }
    return [[NSArray alloc] initWithArray:mutable];
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

-(void) importDome:(Dome*)domeIn Polaris:(int)north Octantis:(int)south
{
    dome = [[Dome alloc] initWithDome:domeIn];
    polaris = north;
    octantis = south;
    size = 33;        // calibrated for preview size
    lineWidth = 1;    //     "
    [self alignPoles];
    [self setNeedsDisplay];
}

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

-(void) setScale:(double)x { size = x; }
-(void) setLineWidth:(CGFloat)x { lineWidth = x; }


// draws an assembly diagram with a size and line width as specified in setScale and setLineWidth
- (void)drawRect:(CGRect)rect
{
    imageForContext = [[UIImage alloc] init];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextClearRect(context, [self bounds]);
    int halfHeight = [self bounds].size.height / 2.0;
    int halfWidth = [self bounds].size.width / 2.0;
    Point3D *point1 = [[Point3D alloc] init];
    Point3D *point2 = [[Point3D alloc] init];
    int count, countByOne;
    double angle, yOffset, scale;
    double lowest = 0;
    double fisheye; /* close-to-sphere domes are further extended at their edges to prevent overlapping lines */

    CGFloat dashedLine[2] = {0.5,1.5};
    
    NSArray *lengthOrder = [[NSArray alloc] initWithArray:[self getLengthOrder]];

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
    
    //double smallestY = 1.9022;
    //double largestY = 0;
    
    int index1, index2;
    countByOne = 0;
    for(count = 0; count < dome.lines_.count; count+=2)
    {
        if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] == 0)[[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0] setStroke];
        else if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] == 1)[[UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0] setStroke];
        else if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] == 2)[[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0] setStroke];
        else if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] == 3)[[UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1.0] setStroke];
        else if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] == 4)[[UIColor colorWithRed:0.65 green:0 blue:0.65 alpha:1.0] setStroke];
        else if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] == 5)[[UIColor colorWithRed:0 green:0.7 blue:0.7 alpha:1.0] setStroke];
        else if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] == 6)[[UIColor colorWithRed:0.95 green:0.65 blue:0.65 alpha:1.0] setStroke];
        else [[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0] setStroke];

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
                /*if(index1 != polaris){
                    if(yOffset < smallestY) smallestY = yOffset;
                    if(yOffset > largestY) largestY = yOffset;
                }*/

                CGContextBeginPath(context);
                CGContextMoveToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                     fisheye*yOffset*cos(angle)*scale+halfHeight);
                angle = atan2([point2 getZ],
                              [point2 getX]);
                yOffset = asin([point2 getY]/1.9022) / (M_PI/2) + 1;

                if(yOffset > 1.63) fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
                else fisheye = 1;
                
                /*if(index2 != polaris){
                    if(yOffset < smallestY) smallestY = yOffset;
                    if(yOffset > largestY) largestY = yOffset;
                }*/
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
    //NSLog(@"Smallest: %.3f, Largest: %.3f",smallestY, largestY);
    //imageForContext = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
}


@end
