#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Room.h"
#import "Curtain.h"
#import "common.c"
//#import "lights.c"

#import "Script.h"

// FACES
#import "Make.h"
#import "NavBar.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]&&([UIScreen mainScreen].scale == 2.0))

// ----- IMPORTANT -----
//
// do not subclass viewDidLoad
// if your curtain has a protocol, make sure you manually set the delegate
//
//

@interface Stage : GLKViewController <NavBarDelegate, MakeDelegate>//<AnimationDelegate>

@property (nonatomic) NSArray *rooms;
@property (nonatomic) NSArray *curtains;

-(void) addRoom:(Room*)room;            // ROOMS   (3D ENVIRONMENTS)
-(void) addCurtain:(Curtain*)curtain;   // SCREENS (ORTHOGRAPHIC LAYERS)

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

@property (nonatomic) unsigned short scene;

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
