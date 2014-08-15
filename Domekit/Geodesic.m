//
//  GeodesicRoom.m
//  Domekit
//
//  Created by Robby on 7/1/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "Geodesic.h"
#include "geodesic.c"

@interface Geodesic ()

@property geodesic geo;
@property geomeshTriangles mesh;

@end

@implementation Geodesic

+(instancetype) room{
    Geodesic *room = [[Geodesic alloc] init];
    return room;
}

-(void) setup{
    _polyhedraType = 1;
    _frequency = 1;
    _geo = icosahedron(1);
    _mesh = makeMeshTriangles(&_geo, 0.85);
}

-(void) draw{
//    geodesicDrawPoints(&_geo);
//    geodesicDrawLines(&_geo);
//    geodesicDrawTriangles(&_geo);
    if(!_hideGeodesic)
        geodesicMeshDrawExtrudedTriangles(&_mesh);
}

-(void) rebuildPolyhedra{
    if(_polyhedraType)
        [self makeIcosahedron];
    else
        [self makeOctahedron];
    
    [self logGeodesic];
}

-(void) logGeodesic{
    if(_polyhedraType)
        NSLog(@"new %dV icosahedral geodesic", _frequency);
    else
        NSLog(@"new %dV octahedral geodesic", _frequency);
    NSLog(@" - points: %d", _geo.numPoints);
    NSLog(@" - lines: %d", _geo.numLines);
    NSLog(@" - faces: %d", _geo.numFaces);
    NSLog(@" - meridians: %d", _geo.numMeridians);
}

-(void) setPolyhedraType:(BOOL)polyhedraType{
    _polyhedraType = polyhedraType;
    [self rebuildPolyhedra];
}

-(void) setFrequency:(NSInteger)frequency{
    _frequency = frequency;
    [self rebuildPolyhedra];
}

-(void)makeIcosahedron{
    deleteGeodesic(&_geo);
    deleteMeshTriangles(&_mesh);
    _geo = icosahedron(_frequency);
    _mesh = makeMeshTriangles(&_geo, 0.85);
}

-(void)makeOctahedron{
    deleteGeodesic(&_geo);
    deleteMeshTriangles(&_mesh);
    _geo = octahedron(_frequency);
    _mesh = makeMeshTriangles(&_geo, 0.85);
}

@end
