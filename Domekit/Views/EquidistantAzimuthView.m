//
//  EquidistantAzimuthView.m
//  Domekit
//
//  Created by Robby on 5/17/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "EquidistantAzimuthView.h"

@interface EquidistantAzimuthView ()

//@property float *points;
//@property float *lines;
//@property unsigned int numPoints;
//@property unsigned int numLines;

@end

@implementation EquidistantAzimuthView

-(id) init{
    self = [super init];
    if(self){
        _scale = defaultScale;
        _lineWidth = defaultLineWidth;
//        _points = malloc(sizeof(float));
//        _lines = malloc(sizeof(float));
//        _numPoints = 1;
//        _numLines = 1;
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _scale = defaultScale;
        _lineWidth = defaultLineWidth;
//        _points = malloc(sizeof(float));
//        _lines = malloc(sizeof(float));
//        _numPoints = 1;
//        _numLines = 1;
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _scale = defaultScale;
        _lineWidth = defaultLineWidth;
//        _points = malloc(sizeof(float));
//        _lines = malloc(sizeof(float));
//        _numPoints = 1;
//        _numLines = 1;
    }
    return self;
}

// MODEL-Y STUFF
// breaking MVC here

-(void) setGeodesic:(GeodesicModel *)geodesic{
    _geodesic = geodesic;
    // build point and line data
    NSDictionary *visible = [_geodesic visiblePointsAndLines];
    _visibleLineIndices = [NSSet setWithArray:[visible objectForKey:@"lines"]];
    _visiblePointIndices = [NSSet setWithArray:[visible objectForKey:@"points"]];
//    free(_points);
//    free(_lines);
//    _points = malloc(sizeof(float)*geodesic.nu);
    [self setNeedsDisplay];
}

//-(void)dealloc{
//    free(_points);
//    free(_lines);
//}

- (void)drawRect:(CGRect)rect
{
    if(!_geodesic) {NSLog(@"Gonna return, no geodesic"); return;}
    if(!_colorTable) {NSLog(@"Gonna return, no colors"); return;}
    
//    imageForContext = [[UIImage alloc] init];
    CGContextRef context = UIGraphicsGetCurrentContext();
    int halfHeight = rect.size.height / 2.0;
    int halfWidth = rect.size.width / 2.0;
    int count;
    double angle, yOffset, scale;
    double lowest = 0;
    double fisheye = 1; // close-to-sphere domes are further extended at their edges to prevent overlapping lines
    
//    CGFloat dashedLine[2] = {0.5,1.5};
    

    float FISHEYE_POINT = 2.0;//0.85699263932702;  // arbitrary

    int octantis = 1;


    scale = _scale*16;///(2.5);

    _scale = _scale * 24;
    
//     FIND THE LOWEST POINT, stretch radius of circle (SCALE) to accomodate
    for(count = 0; count < _geodesic.numPoints; count++)
    {
        
        if( count != octantis &&[_visiblePointIndices containsObject:@(count)])
        {
            yOffset = asin(_geodesic.points[count*3+0]) / (M_PI/2) + 1;
            if(yOffset > lowest)
                lowest = yOffset;
        }
    }
    if(![_visiblePointIndices containsObject:@(octantis)])
    {
        if(lowest > FISHEYE_POINT)
            scale = _scale/(lowest*1.25);
        else scale =
            _scale/(lowest);
    }
    else scale = _scale/(2.5);
    
    
    NSLog(@"FURTHEST: %f",lowest);
    
    NSLog(@"Width: %f",rect.size.width);
    
    float MARGIN = .9; // percent of screen used
    scale = rect.size.width*.5 / lowest * MARGIN;

    
    [[UIColor colorWithWhite:0.0 alpha:1.0] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    
    int index1, index2;
    for(int i = 0; i < _geodesic.numPoints; i++){
        if(_geodesic.points[i*3+0] == 1)
            octantis = i;
    }
    for(count = 0; count < _geodesic.numLines; count++)
    {
        if([_visibleLineIndices containsObject:@(count)]){
        //if( [lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue] < colorTable.count-1)
        //    [(UIColor*)colorTable[[lengthOrder[ [dome.lineClass_[countByOne] integerValue] ]integerValue]] setStroke];
            if( [ _geodesic.lineLengthTypes[count] integerValue] < _colorTable.count-1)
                [(UIColor*)_colorTable[ [_geodesic.lineLengthTypes[count] integerValue]] setStroke];
            else
                [(UIColor*)_colorTable[_colorTable.count-1] setStroke];
    
        
            index1 = _geodesic.lines[count*2+0];
            index2 = _geodesic.lines[count*2+1];
            if(index1 != octantis && index2 != octantis)
            {

                angle = atan2(_geodesic.points[index1*3+2],      //  try changing these
                              _geodesic.points[index1*3+1]);     //
                yOffset = asin(_geodesic.points[index1*3+0]) / (M_PI/2) + 1;
                
//                if(yOffset > FISHEYE_POINT){
////                    NSLog(@"We have a fisheye: %f",yOffset);
//                    fisheye = pow((yOffset-FISHEYE_POINT)/(lowest-FISHEYE_POINT),8)*.25+1;
//                }
//                else
//                    fisheye = 1;
                
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                     fisheye*yOffset*cos(angle)*scale+halfHeight);
                angle = atan2(_geodesic.points[index2*3+2],
                              _geodesic.points[index2*3+1]);
                yOffset = asin(_geodesic.points[index2*3+0]) / (M_PI/2) + 1;
                
//                if(yOffset > FISHEYE_POINT){
////                    NSLog(@"We have a fisheye: %f",yOffset);
//                    fisheye = pow((yOffset-FISHEYE_POINT)/(lowest-FISHEYE_POINT),8)*.25+1;
//                }
//                else
//                    fisheye = 1;
                
                CGContextAddLineToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                        fisheye*yOffset*cos(angle)*scale+halfHeight);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
        // for the one point that is the bottom. the dashed lines extending outward
            else
            {
                if (index1 == octantis)
                {
                    angle = atan2(_geodesic.points[index2*3+2],
                                  _geodesic.points[index2*3+1]);
                    yOffset = asin(_geodesic.points[index2*3+0]) / (M_PI/2) + 1;

//                    if(yOffset > FISHEYE_POINT){
////                        NSLog(@"We have a fisheye: %f",yOffset);
//                        fisheye = pow((yOffset-FISHEYE_POINT)/(lowest-FISHEYE_POINT),8)*.25+1;
//                    }
//                    else
//                        fisheye = 1;
                }
                else//else if(index2 == octantis)
                {
                    angle = atan2(_geodesic.points[index1*3+2],
                                  _geodesic.points[index1*3+1]);
                    yOffset = asin(_geodesic.points[index1*3+0]) / (M_PI/2) + 1;

//                    if(yOffset > FISHEYE_POINT){
////                        NSLog(@"We have a fisheye: %f",yOffset);
//                        fisheye = pow((yOffset-FISHEYE_POINT)/(lowest-FISHEYE_POINT),8)*.25+1;
//                    }
//                    else
//                        fisheye = 1;
                }
                CGContextBeginPath(context);
//                CGContextSetLineDash(context, 0.0f, dashedLine, 2);
//                CGContextSetLineCap(context, kCGLineCapButt);
                CGContextMoveToPoint(context, fisheye*yOffset*sin(angle)*scale+halfWidth,
                                     fisheye*yOffset*cos(angle)*scale+halfHeight);
                CGContextAddLineToPoint(context, fisheye*2*sin(angle)*scale+halfWidth,
                                        fisheye*2*cos(angle)*scale+halfHeight);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
//                CGContextSetLineDash(context, 0, NULL, 0);
//                CGContextSetLineCap(context, kCGLineCapRound);
            }
        }
    }    
}


@end
