#import "Curtain.h"
#import "UIScrollViewSubclass.h"

@protocol MakeDelegate <NSObject>
@required
-(void) icosahedronButtonPressed;
-(void) octahedronButtonPressed;
-(void) frequencySliderChanged:(int)value;
-(void) auxiliaryDraw;  // for scroll view
@end


@interface Make : Curtain <UIGestureRecognizerDelegate>

@property id <MakeDelegate> delegate;

@property NSInteger page;

@property float radioBarPosition;

@property UILabel *titleLabel;
@property NSMutableArray *numberLabels;
@property UIButton *button1;
@property UIButton *button2;

@end