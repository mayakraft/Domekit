//
//  Point3D.h
//  Domekit
//
//  Created by Robby on 1/29/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Point3D : NSObject
{
    double x, y, z;
}

@property double x;
@property double y;
@property double z;

-(id) initWithCoordinatesX:(double)a Y:(double)b Z:(double)c;
-(double) getX;
-(double) getY;
-(double) getZ;

@end
