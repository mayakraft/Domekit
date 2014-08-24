#import <Foundation/Foundation.h>

// Define Scenes here
typedef enum : unsigned short {
    MakeFrequency,
    MakeCrop,
    MakeScale,
    Diagram,
    Share
} Scene;

@protocol SceneTransitionDelegate <NSObject>

@required
// tween increments from 0.0 to 1.0 if transition has duration
-(void) transitionFrom:(unsigned short)fromScene To:(unsigned short)toScene Tween:(float)t;

@optional
-(void) transitionIntoMakeFrequency;
-(void) transitionIntoMakeCrop;
-(void) transitionIntoMakeScale;
-(void) transitionIntoDiagram;
-(void) transitionIntoShare;

-(void) transitionFromMakeFrequency;
-(void) transitionFromMakeCrop;
-(void) transitionFromMakeScale;
-(void) transitionFromDiagram;
-(void) transitionFromShare;
@end

@interface SceneController : NSObject

@property id <SceneTransitionDelegate> delegate;

@property (readonly) Scene scene;
@property (readonly) BOOL sceneInTransition;

-(void) gotoScene:(unsigned short)scene;
-(void) gotoScene:(unsigned short)scene withDuration:(NSTimeInterval)interval;

@end
