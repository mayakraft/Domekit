//
//  NavigationBar.m
//  Domekit
//
//  Created by Robby on 5/6/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        self.userInteractionEnabled = YES;
    } else {
        self.userInteractionEnabled = NO;
    }
    return [super hitTest:point withEvent:event];
}
@end
