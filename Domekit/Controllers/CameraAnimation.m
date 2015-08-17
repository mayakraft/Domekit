#import "CameraAnimation.h"

@interface CameraAnimation ()

@property float FOVStart;
@property float FOVEnd;

// distance from origin
@property float distanceStart;
@property float distanceEnd;

@property double initHeightAtDist;
@property NSTimer *durationTimer;
@end

@implementation CameraAnimation

@synthesize tween;

-(id) initWithName:(NSString *)name Duration:(NSTimeInterval)seconds FramesPerSecond:(float)FramesPerSecond Delegate:(id)delegate StartValue:(float)start EndValue:(float)end{
    self = [super initWithName:name Duration:seconds FramesPerSecond:FramesPerSecond Delegate:delegate StartValue:start EndValue:end];
    if(self){
        _fieldOfView = 68.087608;//56.782191;
        _initHeightAtDist = [self FrustumHeightAtDistance:2 -.4];
    }
    return self;
}


// Calculate the frustum height at a given distance from the camera.
-(double) FrustumHeightAtDistance:(double)distance {
    return 2.0 * distance * tan(_fieldOfView * 0.5 * M_PI / 180.0);
}

// Calculate the FOV needed to get a given frustum height at a given distance.
-(double) FOVForHeightAndDistance:(double)height Distance:(double)distance {
    return 2 * atan(height * 0.5 / distance) / M_PI * 180.0;
}

-(GLKQuaternion) quaternion{
    tween = -[self.startTime timeIntervalSinceNow]/self.duration;
    
    double t = (cos(M_PI - M_PI*tween)+1)*.5;
    GLKQuaternion slerp = GLKQuaternionSlerp(_startOrientation, _endOrientation, powf(t,3));
    
    //    *_FOV = _FOVStart + (_FOVEnd - _FOVStart) * t;
    //    *_distance = _distanceStart + (_distanceEnd - _distanceStart) * t;
    
    if(_reverse)
        t = 1.0-t;
    
    [self dollyZoomFlat:t];
    
    return slerp;
}
-(GLKMatrix4) matrix{
    tween = -[self.startTime timeIntervalSinceNow]/self.duration;
    
    double t = (cos(M_PI - M_PI*tween)+1)*.5;
    GLKQuaternion slerp = GLKQuaternionSlerp(_startOrientation, _endOrientation, powf(t,3));

//    *_FOV = _FOVStart + (_FOVEnd - _FOVStart) * t;
//    *_distance = _distanceStart + (_distanceEnd - _distanceStart) * t;

    if(_reverse)
        t = 1.0-t;

    [self dollyZoomFlat:t];

    return GLKMatrix4MakeWithQuaternion(slerp);
}

-(void) dollyZoomFlat:(double)frame{
    
    // Measure the new distance and readjust the FOV accordingly.
    
    double _distanceFromOrigin = 2;
    _radius = _distanceFromOrigin + pow(frame, 4) * (50);
    _radiusFix = 5 * pow(frame, 4);
//    _radiusFix = 5 * pow((cos(M_PI - M_PI*frame)+1)*.5, 5);
//    _radiusFix = 5 * pow(acos(frame*2-1)/M_PI, 5);
//    _radiusFix = 1-_radiusFix;
    
    _fieldOfView = [self FOVForHeightAndDistance:_initHeightAtDist Distance:_radius];
//    NSLog(@"%f",_radiusFix);

    // 68.087608
}

-(void) animateFrame{
//    NSLog(@"%.2f < %.2f < %.2f", _startTime, elapsedSeconds, _endTime);
    
}

//-(id) step{
//    if(_endTime < [(Stage*)_delegate elapsedSeconds]){
//        [_delegate animationDidStop:self];
//        return nil;
//    }
//    _scale = ([(Stage*)_delegate elapsedSeconds] - _startTime)/_duration;
//    return self;
//}

@end



//typedef struct Animation Animation;
//struct Animation{
//    NSTimeInterval startTime;
//    NSTimeInterval endTime;
//    NSTimeInterval duration;
//    void (*animate)(Stage *s, Animation *a, float elapsedSeconds);
//};
//Animation* makeAnimation(NSTimeInterval start, NSTimeInterval end, void (*animationFunction)(Stage *s, Animation *a, float elapsedSeconds)){
//    Animation *a = malloc(sizeof(Animation));
//    a->startTime = start;
//    a->endTime = end;
//    a->duration = end-start;
//    a->animate = animationFunction;
//    return a;
//}
//Animation* makeAnimationWithDuration(NSTimeInterval start, NSTimeInterval duration, void (*animationFunction)(Stage *s, Animation *a, float elapsedSeconds)){
//    Animation *a = malloc(sizeof(Animation));
//    a->startTime = start;
//    a->endTime = start+duration;
//    a->duration = duration;
//    a->animate = animationFunction;
//    return a;
//}
//void logAnimation(Stage *s, Animation *a, float elapsedSeconds){
//    NSLog(@"%.2f < %.2f < %.2f", a->startTime, elapsedSeconds, a->endTime);
//}
