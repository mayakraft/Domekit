//Draws a simple ruler line

#import "HeightMarker.h"

@implementation HeightMarker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
