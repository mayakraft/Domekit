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

-(void) initUI {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = self.frame.size.height;
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Frequency", @"Slice", @"Scale"]];
    [_segmentedControl setFrame:CGRectMake((w-_segmentedControl.frame.size.width)*.5, (h-_segmentedControl.frame.size.height)*.5, _segmentedControl.frame.size.width, _segmentedControl.frame.size.height)];
    [_segmentedControl setSelectedSegmentIndex:0];
    [self addSubview:_segmentedControl];
    
    // style
    if (@available(iOS 13.0, *)) {
        [_segmentedControl setSelectedSegmentTintColor:[UIColor systemBlueColor]];
            NSDictionary *attributes = @{
                NSForegroundColorAttributeName: [UIColor blackColor]
            };
        NSDictionary *highlightedAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        [_segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    } else {
        // Fallback on earlier versions
    }
}

-(id) init{
    self = [super init];
    if(self){
        [self initUI];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initUI];
    }
    return self;
}
//| ----------------------------------------------------------------------------
//  Called when the view is about to be displayed.  May be called more than
//  once.
//

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    // dark mode
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: [UIColor blackColor]
    };
    NSDictionary *highlightedAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };
    self.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 12.0, *)) {
        if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
            attributes = @{
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            highlightedAttributes = @{
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            self.backgroundColor = [UIColor blackColor];
        } else {
        }
    } else {
    }
    [_segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [_segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];

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
}

@end
