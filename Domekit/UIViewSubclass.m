//
//  UIViewSubclass.m
//  Domekit
//
//  Created by Robby on 7/24/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "UIViewSubclass.h"

@implementation UIViewSubclass

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches began");
    NSLog(@"%@",event);
    NSLog(@"%@",[touches anyObject]);
    NSLog(@"_______________________");
    NSLog(@"%@",[[touches anyObject] gestureRecognizers]);
    [super touchesBegan:touches withEvent:event];
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches MOVED _______________________");
    NSLog(@"%@",[[touches anyObject] gestureRecognizers]);
    [self gestureRecognizers];
    [super touchesMoved:touches withEvent:event];
}
@end
