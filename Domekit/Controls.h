#import "Flat.h"

@protocol ControlsDelegate <NSObject>
@optional
-(void) frequencySliderChanged:(int)value;
@end

@interface Controls : Flat

@property id <ControlsDelegate> delegate;

@property UISlider *slider;
@property UIScrollView *scrollView;

@end
