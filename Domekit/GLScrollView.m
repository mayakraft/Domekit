//
//  GLScrollView.m
//  Domekit
//
//  Created by Robby on 7/6/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "GLScrollView.h"

@implementation GLScrollView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { }
//-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event { }
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { }
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { }


-(BOOL) touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
    NSLog(@"touches should begin");
    return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}

@end
