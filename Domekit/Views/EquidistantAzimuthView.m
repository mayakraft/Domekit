//
//  EquidistantAzimuthView.m
//  Domekit
//
//  Created by Robby on 5/17/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "EquidistantAzimuthView.h"

@implementation EquidistantAzimuthView

-(id) init{
    self = [super init];
    if(self){
        _scale = defaultScale;
        _lineWidth = defaultLineWidth;
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _scale = defaultScale;
        _lineWidth = defaultLineWidth;
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _scale = defaultScale;
        _lineWidth = defaultLineWidth;
    }
    return self;
}


-(void) setGeodesic:(GeodesicModel *)geodesic{
    _geodesic = geodesic;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    if(!_geodesic) {NSLog(@"Gonna return, no geodesic"); return;}
    if(!_colorTable) {NSLog(@"Gonna return, no colors"); return;}
    
//    imageForContext = [[UIImage alloc] init];
    CGContextRef context = UIGraphicsGetCurrentContext();
    int halfHeight = rect.size.height / 2.0;
    int halfWidth = rect.size.width / 2.0;
//    Point3D *point1 = [[Point3D alloc] init];
//    Point3D *point2 = [[Point3D alloc] init];
    int count, countByOne;
    double angle, yOffset, scale;
    double lowest = 0;
    double fisheye; // close-to-sphere domes are further extended at their edges to prevent overlapping lines
    
    CGFloat dashedLine[2] = {0.5,1.5};
    
    //NSArray *lengthOrder = [[NSArray alloc] initWithArray:[self getLengthOrder]];
    
//     FIND THE LOWEST POINT, stretch radius of circle (SCALE) to accomodate
//    for(count = 0; count < dome.points_.count; count++)
//    {
//        if( count != octantis &&[dome.invisiblePoints_[count] boolValue] == FALSE)
//        {
//            yOffset = asin([dome.points_[count] getY]/1.9022) / (M_PI/2) + 1;
//            if(yOffset > lowest) lowest = yOffset;
//        }
//    }
//    if([dome.invisiblePoints_[octantis] boolValue] == TRUE)
//    {
//        if(lowest > 1.63) scale = _scale/(lowest*1.25);
//        else scale = _scale/(lowest);
//    }
//    else scale = _scale/(2.5);
    
    scale = _scale*16;///(2.5);
    
    [[UIColor colorWithWhite:0.0 alpha:1.0] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    int index1, index2;
    int octantis = -1;
    for(int i = 0; i < _geodesic.geo.g.numPoints; i++){
        if(_geodesic.geo.g.points[i*3+0] == -1)
            octantis = i;
    }
//    countByOne = 0;
    for(count = 0; count < _geodesic.geo.g.numLines; count++)
    {
        //if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] < colorTable.count-1)
        //    [(UIColor*)colorTable[[lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue]] setStroke];
        if( [ _geodesic.lineLengthTypes[count] integerValue] < _colorTable.count-1)
            [(UIColor*)_colorTable[ [_geodesic.lineLengthTypes[count] integerValue]] setStroke];
        else
            [(UIColor*)_colorTable[_colorTable.count-1] setStroke];
        
//        if( [dome.invisibleLines_[count] boolValue] == FALSE)
//        {
        
            index1 = _geodesic.geo.g.lines[count*2+0];
            index2 = _geodesic.geo.g.lines[count*2+1];
            if(index1 != octantis && index2 != octantis)
            {

                angle = atan2(_geodesic.geo.g.points[index1*3+2],      //  try changing these
                              _geodesic.geo.g.points[index1*3+1]);     //
                yOffset = asin(-_geodesic.geo.g.points[index1*3+0]) / (M_PI/2) + 1;
//        NSLog(@"YOFF: %f",yOffset);
                
//                if(yOffset > 1.63)
//                    fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
//                else
                    fisheye = 1;
                
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                     fisheye*yOffset*cos(angle)*scale+halfHeight);
                angle = atan2(_geodesic.geo.g.points[index2*3+2],
                              _geodesic.geo.g.points[index2*3+1]);
                yOffset = asin(-_geodesic.geo.g.points[index2*3+0]) / (M_PI/2) + 1;
                
//                if(yOffset > 1.63)
//                    fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
//                else
                    fisheye = 1;
                
                CGContextAddLineToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                        fisheye*yOffset*cos(angle)*scale+halfHeight);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
//        // for the one point that is the bottom. the dashed lines extending outward
//            else
//            {
//                point1 = dome.points_[index1];
//                point2 = dome.points_[index2];
//                if (index1 == octantis)
//                {
//                    angle = atan2([point2 getZ],
//                                  [point2 getX]);
//                    yOffset = asin([point2 getY]/1.9022) / (M_PI/2) + 1;
//                    if(yOffset > 1.63) fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
//                    else fisheye = 1;
//                }
//                else if(index2 == octantis)
//                {
//                    angle = atan2([point1 getZ],
//                                  [point1 getX]);
//                    yOffset = asin([point1 getY]/1.9022) / (M_PI/2) + 1;
//                    if(yOffset > 1.63) fisheye = pow((yOffset-1.63)/(lowest-1.63),8)*.25+1;
//                    else fisheye = 1;
//                }
//                CGContextBeginPath(context);
//                CGContextSetLineDash(context, 0.0f, dashedLine, 2);
//                CGContextSetLineCap(context, kCGLineCapButt);
//                CGContextMoveToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
//                                     fisheye*yOffset*cos(angle)*scale+halfHeight);
//                CGContextAddLineToPoint(context, fisheye*2*sin(angle)*scale+halfWidth,
//                                        fisheye*2*cos(angle)*scale+halfHeight);
//                CGContextClosePath(context);
//                CGContextDrawPath(context, kCGPathFillStroke);
//                CGContextSetLineDash(context, 0, NULL, 0);
//                CGContextSetLineCap(context, kCGLineCapRound);
//            }
//        }
        countByOne++;
    }    
}


@end
