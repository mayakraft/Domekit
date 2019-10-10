//
//  FrequencyControlView.m
//  Domekit
//
//  Created by Robby on 5/7/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "FrequencyControlView.h"


#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad



@implementation FrequencyControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self = [super init];
    if(self)
        [self initSegmentedControl:UIScreen.mainScreen.bounds];
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
        [self initSegmentedControl:UIScreen.mainScreen.bounds];
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
        [self initSegmentedControl:frame];
    return self;
}

-(void) initSegmentedControl:(CGRect)frame{
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    [_segmentedControl setFrame:CGRectMake(frame.size.width*.1, frame.size.height*.33, frame.size.width*.8, frame.size.height*.33)];
    if(IPAD){
        [_segmentedControl setFrame:CGRectMake(frame.size.width*.1, frame.size.height*.45, frame.size.width*.8, frame.size.height*.33)];
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:30]} forState:UIControlStateNormal];
    }
    [_segmentedControl setSelectedSegmentIndex:0];
	// accessibility labels
	for(int i = 0; i < _segmentedControl.subviews.count; i++){
		_segmentedControl.subviews[i].accessibilityLabel = [NSString stringWithFormat:@"frequency %d", i+1];
	}
    [self addSubview:_segmentedControl];
    
    // style
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: [UIColor blackColor]
    };
    NSDictionary *highlightedAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };
    if (@available(iOS 12.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            attributes = @{
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            highlightedAttributes = @{
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
        } else {
        }
    } else {
    }
    [_segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [_segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];

    if (@available(iOS 13.0, *)) {
        [_segmentedControl setSelectedSegmentTintColor:[UIColor systemBlueColor]];
    } else {
        // Fallback on earlier versions
    }
}

@end
