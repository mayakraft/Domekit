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

        _fieldOfView = 68.087608;//56.782191;
        _initHeightAtDist = [self FrustumHeightAtDistance:2 -.4];
//        NSLog(@"HEIGHT AT DIST: %f", _initHeightAtDist);

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

-(GLKMatrix4) matrix{
    double t = -[_startTime timeIntervalSinceNow]/_duration;
    
    t = (cos(M_PI - M_PI*t)+1)*.5;
    GLKQuaternion slerp = GLKQuaternionSlerp(_orientationStart, _orientationEnd, t);

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
    _radius = _distanceFromOrigin + pow(frame, 5) * (50);
    _radiusFix = 5 * pow(frame, 5);
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
