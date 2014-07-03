#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Room.h"
#import "Flat.h"
#import "NavBar.h"
#import "common.c"
#import "Controls.h"
#import "GeodesicRoom.h"
//#import "lights.c"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface Stage : GLKViewController <NavBarDelegate, ControlsDelegate>//<AnimationDelegate>

@property (nonatomic) Room *room;         // ROOMS   (3D ENVIRONMENTS)
@property (nonatomic) Flat *flat;         // SCREENS (ORTHOGRAPHIC LAYERS)
@property (nonatomic) NavBar *navBar;     // SCREENS (ORTHOGRAPHIC LAYERS)

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

//+(instancetype) StageWithRoom:(Room*)room Flat:(Flat*)flat NavBar:(NavBar*)navBar;

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
