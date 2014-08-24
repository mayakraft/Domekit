#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Room.h"
#import "Curtain.h"
#import "common.c"
//#import "lights.c"
#import "SceneController.h"  // Stage.h ?

#import "Make.h"
#import "NavBar.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]&&([UIScreen mainScreen].scale == 2.0))

// ----- IMPORTANT -----
//
// do not subclass viewDidLoad
// if your curtain has a protocol, make sure you manually set the delegate
//

@interface Stage : GLKViewController <SceneTransitionDelegate, NavBarDelegate, MakeDelegate>//<AnimationDelegate>

@property SceneController *script;

@property (nonatomic) NSArray *rooms;     // ROOMS   (3D ENVIRONMENTS)
@property (nonatomic) NSArray *curtains;  // SCREENS (ORTHOGRAPHIC LAYERS)

-(void) addRoom:(Room*)room;
-(void) addCurtain:(Curtain*)curtain;

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
