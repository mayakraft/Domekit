//
//  UIScrollViewSubclass.m
//  Domekit
//
//  Created by Robby on 7/29/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "UIScrollViewSubclass.h"

@implementation UIScrollViewSubclass

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _noTouchRects = [NSArray array];
    }
    return self;
}


-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    float arrowWidth = self.frame.size.width*.175;
    float margin = self.superview.bounds.size.width*.1;
    CGRect frequencySliderRect = CGRectMake(margin, self.frame.size.height-arrowWidth*2.5, self.frame.size.width-margin*2, arrowWidth*2.5);
    
    if(CGRectContainsPoint(frequencySliderRect, [touch locationInView:self.superview]))
        return 0;
    return 1;
}

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    CGPoint pointOfContact = [gestureRecognizer locationInView:self.superview];
//    NSLog(@"%d", [_noTouchRects count]);
//    for(int i = 0; i < [_noTouchRects count]; i++){
//        CGRect r = [[_noTouchRects objectAtIndex:i] CGRectValue];
//        NSLog(@"%f, %f :: %f, %f, %f, %f",pointOfContact.x, pointOfContact.y, r.origin.x, r.origin.y, r.size.width, r.size.height);
//        if(CGRectContainsPoint(r, pointOfContact)){
//            NSLog(@"DENIED");
//            UITouch *touch = [[UITouch alloc] init];
//
//            NSSet *touches = [NSSet setWithArray:@[[UITouch ]]];
//            UIEvent *event = [UIEvent new];
//            [self.nextResponder touchesBegan:touches withEvent:event];
//            return 0;
//        }
//    }
//    NSLog(@"gesture okay");
//    return 1;
//}


@end
