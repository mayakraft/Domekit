#import "Room.h"

@implementation Room

+(instancetype) room{
    Room *room = [[Room alloc] init];
    return room;
}

-(id)init{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(void) setup{
    // implement this function
    // in your subclass
}

-(void) draw{
    // implement this function
    // in your subclass
}

@end
