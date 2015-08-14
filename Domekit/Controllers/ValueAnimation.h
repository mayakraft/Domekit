//
//  ValueAnimation.h
//  Domekit
//
//  Created by Robby on 8/13/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ValueAnimation;

@protocol ValueAnimationDelegate
-(void) valueAnimationDidStop:(ValueAnimation*)sender;
-(void) valueAnimationDidUpdate:(ValueAnimation*)sender;
@end

@interface ValueAnimation : NSObject

// delegate callback when animation is done
@property id <ValueAnimationDelegate> delegate;

// probably most useful function
// initialize an animation,
// it runs
// it calls the delegate when it's done
//-(id)initWithDuration:(NSTimeInterval)seconds;
-(id)initWithName:(NSString*)name Duration:(NSTimeInterval)seconds Delegate:(id)delegate StartValue:(float)start EndValue:(float)end;


@property (readonly) float value;  // grab your value here
@property (readonly) double tween;  // progress from start to finish  (0.0 to 1.0)


@property (readonly) NSString *name;
@property (readonly) NSDate *startTime;
@property (readonly) NSDate *endTime;
@property (readonly) NSTimeInterval duration;


// SET THIS TRUE
// TO PLAY ANIMATION IN REVERSE
//@property BOOL reverse;



@end
