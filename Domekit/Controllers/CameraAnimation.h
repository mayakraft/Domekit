#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ValueAnimation.h"

@interface CameraAnimation : ValueAnimation

// read this at any time during the animation
// it will return the camera's present state

@property (readonly) GLKQuaternion quaternion;
@property (readonly) GLKMatrix4 matrix;


@property double fieldOfView; // animated

@property double radius;
@property double radiusFix;  // same as above

// SET THIS TRUE
// TO PLAY ANIMATION IN REVERSE
@property BOOL reverse;

@property GLKQuaternion startOrientation;
@property GLKQuaternion endOrientation;

@end
