#import <OpenGLES/ES1/gl.h>
#import "Flat.h"

@interface Flat (){
    float _aspectRatio;
    float width, height;
}
@end

@implementation Flat

-(id) init{
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

-(id) initWithFrame:(CGRect)frame{
    self = [super init];
    if(self){
        _frame = frame;
        _view = [[UIView alloc] initWithFrame:frame];
//        _elements = [[NSMutableArray alloc] init];
        width = _frame.size.width;
        height = _frame.size.height;
        _aspectRatio = _frame.size.width/_frame.size.height;
        [self setup];
    }
    return self;
}

-(void) draw{
    [self enterOrthographic];
    [self customDraw];
    [self exitOrthographic];
}

-(void) customDraw{
    // implement this function
    // in your subclass
}

-(void) setup{
    // implement this function
    // in your subclass
}

-(void) hideElements{ }

-(void) setNeedsLayout{ }

-(void)enterOrthographic{
    glDisable(GL_DEPTH_TEST);
//    glDisable(GL_CULL_FACE);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, width, 0, height, -5, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
}

-(void)exitOrthographic{
    glEnable(GL_DEPTH_TEST);
//    glEnable(GL_CULL_FACE);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

@end
