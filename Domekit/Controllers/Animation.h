#import <Foundation/Foundation.h>

@class Animation;

@protocol AnimationDelegate <NSObject>

-(void) animationDidStop:(Animation*)a;

@end

@interface Animation : NSObject

@property id <AnimationDelegate> delegate;

@property NSDate *startTime;
@property NSDate *endTime;
@property NSTimeInterval duration;

@property float tween;  // 0.0 to 1.0, start to end

-(id)initWithStart:(NSDate*)start End:(NSDate*)end;
-(id)initAndStartNowWithDuration:(NSTimeInterval)duration;

-(void) animateFrame;
//-(id) step;

@end
