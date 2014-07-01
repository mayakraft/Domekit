#import <Foundation/Foundation.h>

@interface Room : NSObject

+(instancetype) room;  // must subclass and implement with your custom class name

-(void) setup;  // implement these
-(void) draw;   // in your subclass

@end
