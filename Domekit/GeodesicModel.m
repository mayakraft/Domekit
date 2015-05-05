//
//  GeodesicRoom.m
//  Domekit
//
//  Created by Robby on 7/1/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "GeodesicModel.h"
#import <OpenGLES/ES1/gl.h>
#import "OpenGL/mesh.c"

@interface GeodesicModel ()

@end

@implementation GeodesicModel

-(id) initWithFrequency:(unsigned int)frequency Solid:(PolyhedronSeed)solid{
    if(!frequency)
        return nil;
    self = [super init];
    if(self){
        if(solid == TETRAHEDRON_SEED)
            _geo = tetrahedronSphere(frequency);
        else if(solid == OCTAHEDRON_SEED)
            _geo = octahedronSphere(frequency);
        else
            _geo = icosahedronSphere(frequency);
        _mesh = makeMeshTriangles(&_geo, 0.85);
    }
    return self;
}

-(id) initWithFrequency:(unsigned int)frequency{
    return [self initWithFrequency:frequency Solid:0];
}

-(id) init{
    return [self initWithFrequency:1 Solid:0];
}


-(void) rebuildPolyhedra{
    if(_solid == TETRAHEDRON_SEED)
        [self makeTetrahedron];
    else if(_solid == OCTAHEDRON_SEED)
        [self makeOctahedron];
    else
        [self makeIcosahedron];

    [self logGeodesic];
}

-(void) logGeodesic{
    if(_solid == 2)
        NSLog(@"new %dV tetrahedral geodesic", _frequency);
    else if(_solid == 1)
        NSLog(@"new %dV octahedral geodesic", _frequency);
    else
        NSLog(@"new %dV icosahedral geodesic", _frequency);
    NSLog(@" - points: %d", _geo.numPoints);
    NSLog(@" - lines: %d", _geo.numLines);
    NSLog(@" - faces: %d", _geo.numFaces);
//    NSLog(@" - meridians: %d", _geo.numMeridians);
}

-(void) setSolid:(PolyhedronSeed)solid{
    _solid = solid;
    [self rebuildPolyhedra];
}
-(void) setFrequency:(unsigned int)frequency{
    _frequency = frequency;
    [self rebuildPolyhedra];
}

-(void) makeTetrahedron{
    #warning incomplete
}

-(void)makeIcosahedron{
    deleteGeodesicSphere(&_geo);
    deleteMeshTriangles(&_mesh);
    _geo = icosahedronSphere(_frequency);
    _mesh = makeMeshTriangles(&_geo, 0.85);
}

-(void)makeOctahedron{
    deleteGeodesicSphere(&_geo);
    deleteMeshTriangles(&_mesh);
    _geo = octahedronSphere(_frequency);
    _mesh = makeMeshTriangles(&_geo, 0.85);
}

@end
