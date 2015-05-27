#import "CameraAnimation.h"

@interface CameraAnimation ()
@property GLKQuaternion orientationStart;
@property GLKQuaternion orientationEnd;

@property float FOVStart;
@property float FOVEnd;

// distance from origin
@property float distanceStart;
@property float distanceEnd;

@property NSTimer *durationTimer;
@end

@implementation CameraAnimation

-(id)initWithStart:(NSDate*)start End:(NSDate*)end{
    self = [super init];
    if (self) {
        _startTime = start;
        _endTime = end;
//        _duration = end-start;
        // TODO: is this next right?
        _duration = [_startTime timeIntervalSinceNow] - [_endTime timeIntervalSinceNow];
//        _delegate = stage;
    }
    return self;
}

-(id)initWithDuration:(NSTimeInterval)seconds Delegate:(id)delegate OrientationStart:(GLKQuaternion)orientationStart End:(GLKQuaternion)orientationEnd {
//-(id)initWithDuration:(NSTimeInterval)seconds OrientationStart:(GLKQuaternion)orientationStart End:(GLKQuaternion)orientationEnd FieldOfViewStart:(float)FOVStart End:(float)FOVEnd FOVPointer:(float*)FOV DistanceStart:(float)distanceStart DistanceEnd:(float)distanceEnd DistancePointer:(float*)distance{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _startTime = [NSDate date];
        _endTime = [_startTime dateByAddingTimeInterval:seconds];
        _duration = seconds;

        _orientationStart = orientationStart;
        _orientationEnd = orientationEnd;
        
        _durationTimer = [NSTimer scheduledTimerWithTimeInterval:_duration target:_delegate selector:@selector(animationDidStop:) userInfo:nil repeats:NO];
    }
    return self;
}

-(GLKMatrix4) matrix{
    float t = -[_startTime timeIntervalSinceNow]/_duration;
    GLKQuaternion slerp = GLKQuaternionSlerp(_orientationStart, _orientationEnd, t);

//    *_FOV = _FOVStart + (_FOVEnd - _FOVStart) * t;
//    *_distance = _distanceStart + (_distanceEnd - _distanceStart) * t;

    t = pow(t, 3);
    [self dollyZoomFlat:t];

    return GLKMatrix4MakeWithQuaternion(slerp);
}

-(void) dollyZoomFlat:(float)frame{
    
    float _distanceFromOrigin = 2;
    _radius = _distanceFromOrigin + frame * 50;//50;

    float width = 5.3;
    
    
    float fov = 2 * atan(width / (2 * (_radius+_distanceFromOrigin)));
//    _fieldOfView = fov / 3.1415926 * 180.0;
    _fieldOfView = fov / 3.1415926 * 180.0; //68.087608 * atan( width /(2*_radius));//(1-frame);
//    _fieldOfView = 2 + 66.087608 * fov;
    NSLog(@"(%f) FOV (%f): %f",_radius, atan( width /(2*_radius)), _fieldOfView);
    //    NSLog(@"FOV %f",fov);
    //    build_projection_matrix(self.frame.origin.x, self.frame.origin.y, (1+IS_RETINA)*self.frame.size.width, (1+IS_RETINA)*self.frame.size.height, fov);
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
