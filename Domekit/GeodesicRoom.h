//
//  GeodesicRoom.h
//  Domekit
//
//  Created by Robby on 7/1/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "Room.h"

@interface GeodesicRoom : Room

@property NSInteger frequency;
@property NSString *polyhedraType;

-(void) makeGeodesic:(int)frequency;

@property BOOL hideGeodesic;

@end
