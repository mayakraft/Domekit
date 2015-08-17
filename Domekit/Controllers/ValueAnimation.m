//
//  ValueAnimation.m
//  Domekit
//
//  Created by Robby on 8/13/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "ValueAnimation.h"

@interface ValueAnimation ()
@property float startValue;
@property float endValue;
@property float deltaValue;
@property NSTimer *endTimer, *durationTimer;
@end

@implementation ValueAnimation

-(id) initWithName:(NSString *)name Duration:(NSTimeInterval)seconds FramesPerSecond:(float)framesPerSecond Delegate:(id)delegate StartValue:(float)start EndValue:(float)end{
    self = [super init];
    if(self){
        
        _name = name;
        
        _delegate = delegate;
        _startTime = [NSDate date];
        _endTime = [_startTime dateByAddingTimeInterval:seconds];
        _duration = seconds;
        
        _value = _startValue = start;
        _endValue = end;
        
        _fps = framesPerSecond;
        
        _endTimer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(animationWillStop) userInfo:nil repeats:NO];
        _durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/_fps target:self selector:@selector(animationDidUpdate) userInfo:nil repeats:YES];
    }
    return self;
}

-(void) updateValue{
    _value = _startValue + (_endValue - _startValue) * _tween;
}

-(void) animationWillStop{
    [_durationTimer invalidate];
    _durationTimer = nil;
    _value = _endValue;
    [_delegate valueAnimationDidStop:self];
}

-(void) animationDidUpdate{
    _tween = -[_startTime timeIntervalSinceNow]/_duration;
    [self updateValue];
    [_delegate valueAnimationDidUpdate:self];
}

@end
