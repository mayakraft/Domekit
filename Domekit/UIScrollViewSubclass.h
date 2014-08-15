//
//  UIScrollViewSubclass.h
//  Domekit
//
//  Created by Robby on 7/29/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollViewSubclass : UIScrollView <UIGestureRecognizerDelegate>

@property NSArray *noTouchRects;

@end
