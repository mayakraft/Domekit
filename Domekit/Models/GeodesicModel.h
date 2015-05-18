//
//  GeodesicRoom.h
//  Domekit
//
//  Created by Robby on 7/1/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "OpenGL/mesh.h"

//
// Obj-C wrapper for the C-struct geodesic geometry object
//

typedef enum : NSUInteger {
    ICOSAHEDRON_SEED,
    OCTAHEDRON_SEED,
    TETRAHEDRON_SEED,
} PolyhedronSeed;

@interface GeodesicModel : NSObject

-(id) initWithFrequency:(unsigned int)frequency;  // Assumes Icosahedron
-(id) initWithFrequency:(unsigned int)frequency Solid:(PolyhedronSeed)solid;

@property (nonatomic) NSArray *slicePoints;

@property (nonatomic) NSArray *lineClassLengths;
@property (nonatomic) NSArray *lineClass;

@property (nonatomic) unsigned int frequency;
@property (nonatomic) PolyhedronSeed solid; // 0:icosahedron  1:octahedron  2:tetrahedron

@property geodesicDome geo;
@property geodesicMeshTriangles mesh;
//@property geodesicMeshCropPlanes meridiansMesh;
@property geodesicMeshSlicePoints sliceMeridians;

@end
