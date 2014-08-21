//
//  GeodesicRoom.h
//  Domekit
//
//  Created by Robby on 7/1/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "Room.h"

@interface Geodesic : Room

@property (nonatomic) NSInteger frequency;  // these are the kinds of variables which are really just copies of
@property (nonatomic) BOOL polyhedraType;   // variables inside the lower-level c method and objects. it is required
                                            // that they always reflect the state of the variables which they are copies of
                                            // btw, do these things have a name?
@property BOOL hideGeodesic;

@end
