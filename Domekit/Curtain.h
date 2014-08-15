#import "Primitives.h"
#import "Hotspot.h"
#import <GLKit/GLKit.h>
//@protocol CurtainDelegate <NSObject>
//
//@optional
//
//@end

@interface Curtain : Primitives

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

//@property id <CurtainDelegate> delegate;

@property GLKView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;

//@property NSMutableArray *elements;   // add all user interface elements here after creating
//@property (nonatomic) NSArray *hotspots;
//-(void) hideElements;                 // so that this function will work

-(id) initWithFrame:(CGRect)frame;

-(void) setNeedsLayout;

//TODO: how do you say "REQUIRED"

/*!
 * Append any OpenGL draw calls here
 * \param no params
 * \returns nothing
 */
-(void) customDraw;

/*!
 * Implement custom UIKit elements here
 * \param no params
 * \returns nothing
 */
-(void) setup;

/*!
 * Leave this function un-implemented!
 */
-(void) draw;

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
