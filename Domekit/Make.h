#import "Face.h"

@protocol MakeDelegate <NSObject>
@required
-(void) icosahedronButtonPressed;
-(void) octahedronButtonPressed;
-(void) frequencySliderChanged:(int)value;
@end

@interface Make : Face

@property id <MakeDelegate> delegate;

@property UISlider *slider;
@property UIScrollView *scrollView;

@end
