#import "Primitives.h"
#import "Hotspot.h"

//@protocol FlatDelegate <NSObject>
//
//@optional
//
//@end

@interface Flat : Primitives

//@property id <FlatDelegate> delegate;

@property UIView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;

//@property NSMutableArray *elements;   // add all user interface elements here after creating
//@property (nonatomic) NSArray *hotspots;
//-(void) hideElements;                 // so that this function will work

-(id) initWithFrame:(CGRect)frame;

-(void) setNeedsLayout;

//TODO: how do you say "REQUIRED"
-(void) customDraw;
-(void) setup;
-(void) draw;

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
