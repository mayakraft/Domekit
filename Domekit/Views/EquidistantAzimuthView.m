//
//  EquidistantAzimuthView.m
//  Domekit
//
//  Created by Robby on 5/17/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "EquidistantAzimuthView.h"

@implementation EquidistantAzimuthView


//-(void) willMoveToSuperview:(UIView *)newSuperview{
//    NSLog(@"this happened");
//    [self setBackgroundColor:[UIColor orangeColor]];
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}


/*
- (void)drawRect:(CGRect)rect {
    //    static GLfloat whiteColor[] = {1.0f, 1.0f, 1.0f, 1.0f};
    //    static GLfloat clearColor[] = {0.0f, 0.0f, 0.0f, 0.0f};
    glClearColor(1.0f, 1.0f, 1.5f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPushMatrix(); // begin device orientation
    
    //    _attitudeMatrix = GLKMatrix4Multiply([self getDeviceOrientationMatrix], _offsetMatrix);
    
    //    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);  // panorama at full color
    //    [sphere execute];
    //    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, clearColor);
    //        [meridians execute];  // semi-transparent texture overlay (15° meridian lines)
    
    static perspective_t POV = ORTHO;
    switch(POV){
        case FPP:
            glMultMatrixf(_attitudeMatrix.m);
            //            // raise POV 1.0 above the floor, 1.0 is an arbitrary value
            glTranslatef(0, 0, -1.0f);
            break;
            
        case POLAR:
            glTranslatef(0, 0, -polarRadius);
            glMultMatrixf(_attitudeMatrix.m);
            break;
            
        case ORTHO:
            glTranslatef(-mouseTotalOffsetX * .05, mouseTotalOffsetY * .05, 0.0f);
            break;
    }
    
    //    glDisable(GL_LIGHTING);
    //    glPushMatrix();
    //        [self drawCheckerboardX:0 Y:0 NumberSquares:4];
    //    glPopMatrix();
    
    glEnable(GL_LIGHTING);
    
    glPushMatrix();
    //        glTranslatef(0, 0, 1.0f);
    [self drawTriangles];
    glPopMatrix();
    
    glPopMatrix(); // end device orientation
}




// draws an assembly diagram with a size and line width as specified in setScale and setLineWidth
- (void)drawRect:(CGRect)rect
{
    imageForContext = [[UIImage alloc] init];
    CGContextRef context = UIGraphicsGetCurrentContext();
    int halfHeight = [self bounds].size.height / 2.0;
    int halfWidth = [self bounds].size.width / 2.0;
    Point3D *point1 = [[Point3D alloc] init];
    Point3D *point2 = [[Point3D alloc] init];
    int count, countByOne;
    double angle, yOffset, scale;
    double lowest = 0;
    double fisheye; // close-to-sphere domes are further extended at their edges to prevent overlapping lines
    
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
}

*/

@end
