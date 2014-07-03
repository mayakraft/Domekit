//
//  HitTestView.m
//  Domekit
//
//  Created by Robby on 7/2/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "HitTestView.h"

@implementation HitTestView

- (instancetype)initWithFrame:(CGRect)frame View:(UIView*)redirected
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _redirected = redirected;
    }
    return self;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return _redirected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
