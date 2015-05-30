#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class CameraAnimation;

@protocol CameraAnimationDelegate <NSObject>
-(void) animationDidStop:(GLKMatrix4)matrix;
@end

@interface CameraAnimation : NSObject

// delegate callback when animation is done
@property id <CameraAnimationDelegate> delegate;

// read this at any time during the animation
// it will return the camera's present state
@property (readonly) GLKMatrix4 matrix;

// probably most useful function
// initialize an animation,
// it runs
// it calls the delegate when it's done
//-(id)initWithDuration:(NSTimeInterval)seconds;
-(id)initWithDuration:(NSTimeInterval)seconds Delegate:(id)delegate OrientationStart:(GLKQuaternion)orientationStart End:(GLKQuaternion)orientationEnd FieldOfViewStart:(float)FOVStart End:(float)FOVEnd DistanceStart:(float)distanceStart DistanceEnd:(float)distanceEnd;

-(id)initWithDuration:(NSTimeInterval)seconds Delegate:(id)delegate OrientationStart:(GLKQuaternion)orientationStart End:(GLKQuaternion)orientationEnd;


@property double fieldOfView; // animated

@property double radius;
@property double radiusFix;  // same as above

// SET THIS TRUE
// TO PLAY ANIMATION IN REVERSE
@property BOOL reverse;


@property GLKQuaternion orientationStart;
@property GLKQuaternion orientationEnd;

// extra
// choose an optional start and end time
-(id)initWithStart:(NSDate*)start End:(NSDate*)end;

// 0.0 to 1.0
// progress from start to finish
@property (readonly) double tween;

@property (readonly) NSDate *startTime;
@property (readonly) NSDate *endTime;
@property (readonly) NSTimeInterval duration;

@end
