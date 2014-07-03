//
//  HitTestView.h
//  Domekit
//
//  Created by Robby on 7/2/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HitTestView : UIView
@property (nonatomic) UIView *redirected;
- (instancetype)initWithFrame:(CGRect)frame View:(UIView*)redirected;
@end
