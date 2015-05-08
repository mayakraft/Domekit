/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A UIView subclass that draws a gray hairline along its bottom
  border, similar to a navigation bar.  This view is used as the navigation
  bar extension view in the Extended Navigation Bar example.
 */

#import "ExtendedNavBarView.h"

@implementation ExtendedNavBarView

//| ----------------------------------------------------------------------------
//  Called when the view is about to be displayed.  May be called more than
//  once.
//

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    // Use the layer shadow to draw a one pixel hairline under this view.
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f/UIScreen.mainScreen.scale)];
    [self.layer setShadowRadius:0];
    
    // UINavigationBar's hairline is adaptive, its properties change with
    // the contents it overlies.  You may need to experiment with these
    // values to best match your content.
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.25f];
    
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = self.frame.size.height;
    
    [_segmentedControl setFrame:CGRectMake((w-_segmentedControl.frame.size.width)*.5, (h-_segmentedControl.frame.size.height)*.5, _segmentedControl.frame.size.width, _segmentedControl.frame.size.height)];
//    [segmentedControl setFrame:CGRectMake(w*.1, h*.75, w*.8, h*.05)];
    [_segmentedControl setSelectedSegmentIndex:0];
    [self addSubview:_segmentedControl];
}

@end
