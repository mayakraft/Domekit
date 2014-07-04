#import "Face.h"

@protocol MakeDelegate <NSObject>
@required
-(void) icosahedronButtonPressed;
-(void) octahedronButtonPressed;
-(void) frequencySliderChanged:(int)value;
-(void) auxiliaryDraw;  // for scroll view
@end

@interface Make : Face <UIScrollViewDelegate>

@property id <MakeDelegate> delegate;

@property UISlider *slider;
@property UIScrollView *scrollView;

@end
