//
//  HeightMarker.m
//  Domekit
//
//  Created by Robby on 2/16/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "HeightMarker.h"

@implementation HeightMarker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

//    rect.size.width
    
    [[UIColor colorWithWhite:0.0 alpha:1.0] setStroke];
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGContextMoveToPoint(context,0,0 );
    CGContextAddLineToPoint(context, rect.size.width, 0.0);
    
    CGContextMoveToPoint(context,0,rect.size.height );
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);

    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextSetLineWidth(context, 1.0);

    CGContextMoveToPoint(context,rect.size.width/2.0,0 );
    CGContextAddLineToPoint(context, rect.size.width/2.0, rect.size.height);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    

}


@end
