//
//  GeodesicRoom.m
//  Domekit
//
//  Created by Robby on 7/1/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "GeodesicRoom.h"
#include "geodesic.c"

@interface GeodesicRoom ()

@property geodesic geo;
@property geomeshTriangles mesh;

@end

@implementation GeodesicRoom

+(instancetype) room{
    GeodesicRoom *room = [[GeodesicRoom alloc] init];
    return room;
}

-(void) setup{
    _geo = icosahedron(1);
    _mesh = makeMeshTriangles(&_geo, 0.85);
}

-(void) draw{
//    geodesicDrawPoints(&_geo);
//    geodesicDrawLines(&_geo);
//    geodesicDrawTriangles(&_geo);
    
    geodesicMeshDrawExtrudedTriangles(&_mesh);
}

-(void)makeGeodesic:(int)frequency{
    deleteGeodesic(&_geo);
    deleteMeshTriangles(&_mesh);
    _geo = icosahedron(frequency);
    _mesh = makeMeshTriangles(&_geo, 0.85);
}

@end
