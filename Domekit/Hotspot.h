#import <UIKit/UIKit.h>

//typedef NS_OPTIONS(NSUInteger, HotspotScene) {
//    scene1 = 1 << 0,
//    scene2 = 1 << 1,
//    scene3 = 1 << 2,
//};

@interface Hotspot : NSObject

@property CGRect bounds;
@property int scene;
@property NSInteger ID;
//@property function pointer

+ (instancetype)hotspotWithID:(NSInteger)i Bounds:(CGRect)rect;

+ (instancetype)hotspotWithID:(NSInteger)i Scene:(int)validScenes Bounds:(CGRect)rect;  //TODO: valid scene should be array

@end
