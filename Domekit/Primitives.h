#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>

@interface Primitives : NSObject

/* 2D PRIMITIVES */

-(void) drawRect:(CGRect)rect;
-(void) drawRectOutline:(CGRect)rect;
-(void) drawHexagons;
-(void) drawHexLines;

-(void) drawRect:(CGRect)rect WithRotation:(float)degrees;

@end