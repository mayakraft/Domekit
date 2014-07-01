#import "Hotspot.h"

@implementation Hotspot

+(instancetype)hotspotWithID:(NSInteger)i Bounds:(CGRect)rect{
    Hotspot *h = [[Hotspot alloc] init];
    if(h){
        [h setBounds:rect];
        [h setScene:0];
        [h setID:i];
    }
    return h;
}

+ (instancetype)hotspotWithID:(NSInteger)i Scene:(int)validScenes Bounds:(CGRect)rect{
    Hotspot *h = [[Hotspot alloc] init];
    if(h){
        [h setBounds:rect];
        [h setScene:validScenes];
        [h setID:i];
    }
    return h;
}
@end
