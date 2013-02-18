//
//  Point3D.m
//  Domekit
//
//  Created by Robby on 1/29/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "Point3D.h"

@implementation Point3D

@synthesize x;
@synthesize y;
@synthesize z;


-(id) initWithCoordinatesX:(double)a Y:(double)b Z:(double)c
{
    x = a;
    y = b;
    z = c;
    return self;
}
-(double) getX { return x;}
-(double) getY { return y;}
-(double) getZ { return z;}

@end
