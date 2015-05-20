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
        _frequency = frequency;
        if(solid == ICOSAHEDRON_SEED)
            _geo = icosahedronDome(_frequency, 1.0);
        else if(solid == OCTAHEDRON_SEED)
            _geo = octahedronDome(_frequency, 1.0);
        //        if(solid == TETRAHEDRON_SEED)
        //            _geo = tetrahedronSphere(frequency);
//        if(solid == OCTAHEDRON_SEED)
//            _geo = octahedronSphere(frequency);
//        else
//            _geo = icosahedronSphere(frequency);
        
        _mesh = makeMeshTriangles(&(_geo.g), 0.85);
        _sliceMeridians = makeMeshSlicePoints(&(_geo));
//        _meridiansMesh = makeMeshCropPlanes(&(_geo));
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
//    if(_solid == TETRAHEDRON_SEED)
//        [self makeTetrahedron];
    if(_solid == OCTAHEDRON_SEED)
        [self makeOctahedron];
    else
        [self makeIcosahedron];

    [self logGeodesic];
}

-(NSArray *)faceAltitudeCountsCumulative{
    NSMutableArray *counts = [NSMutableArray array];
    for(int i = 0; i < _geo.numMeridians; i++){
        if(i == 0)
            [counts addObject:[NSNumber numberWithUnsignedInt:_geo.faceAltitudeCounts[i]]];
        else
            [counts addObject:[NSNumber numberWithUnsignedInt:_geo.faceAltitudeCounts[i] + [counts[i-1] unsignedIntValue]]];
    }
    return counts;
}

-(NSArray*)slicePoints {
    NSMutableArray *points = [NSMutableArray array];
    for(int i = 0 ;i < _geo.numSlicePoints; i++)
        [points addObject:[NSNumber numberWithFloat:_geo.slicePoints[i]]];
    return points;
}

-(void) makeLineClasses{
    geodesicAnalysis a = classifyLines(&_geo.g);
    NSLog(@"part 2, entering");
    NSMutableArray *types = [NSMutableArray array];
    for(int i = 0; i < _geo.g.numLines; i++){
        printf("%d %d\n",i, a.lineLengthTypes[i]);
        [types addObject:[NSNumber numberWithUnsignedInt:a.lineLengthTypes[i]]];
    }
    _lineLengthTypes = types;
    
    NSLog(@"part 2, midway");

    NSMutableArray *values = [NSMutableArray array];
    for(int i = 0; i < a.numLineLengths; i++)
        [values addObject:[NSNumber numberWithDouble:a.lineLengthValues[i]]];
    _lineLengthValues = values;
    NSLog(@"part 2, exiting");
}

-(void) logGeodesic{
    if(_solid == 2)
        NSLog(@"new %dV tetrahedral geodesic", _frequency);
    else if(_solid == 1)
        NSLog(@"new %dV octahedral geodesic", _frequency);
    else
        NSLog(@"new %dV icosahedral geodesic", _frequency);
    NSLog(@" - points: %d", _geo.g.numPoints);
    NSLog(@" - lines: %d", _geo.g.numLines);
    NSLog(@" - faces: %d", _geo.g.numFaces);
//    NSLog(@" - meridians: %d", _geo.numMeridians);
}

-(void) setSolid:(PolyhedronSeed)solid{
    NSLog(@"setting solid type");
    _solid = solid;
    [self rebuildPolyhedra];
}
-(void) setFrequency:(unsigned int)frequency{
    _frequency = frequency;
    [self rebuildPolyhedra];
}

//-(void) setCropEnabled:(BOOL)cropEnabled{
//    _cropEnabled = cropEnabled;
//    if(_solid == 0)
//        _dome = icosahedronDome(_frequency, 1.0);
//    else if(_solid == 1)
//        _dome = octahedronDome(_frequency, 1.0);
//}

//-(void) makeTetrahedron{
//    #warning incomplete
//}

-(void)makeIcosahedron{
    deleteGeodesicDome(&_geo);
    deleteMeshTriangles(&_mesh);
    deleteSlicePoints(&_sliceMeridians);
//    deleteCropPlanes(&_meridiansMesh);
    _geo = icosahedronDome(_frequency, 1.0);
    _mesh = makeMeshTriangles(&(_geo.g), 0.85);
    _sliceMeridians = makeMeshSlicePoints(&(_geo));
//    _meridiansMesh = makeMeshCropPlanes(&(_geo));
    
//    deleteGeodesicSphere(&_geo);
//    deleteMeshTriangles(&_mesh);
//    _geo = icosahedronSphere(_frequency);
//    _mesh = makeMeshTriangles(&_geo, 0.85);
}

-(void)makeOctahedron{
    deleteGeodesicDome(&_geo);
    deleteMeshTriangles(&_mesh);
    deleteSlicePoints(&_sliceMeridians);
//    deleteCropPlanes(&_meridiansMesh);
    _geo = octahedronDome(_frequency, 1.0);
    _mesh = makeMeshTriangles(&(_geo.g), 0.85);
//    _meridiansMesh = makeMeshCropPlanes(&(_geo.g));
    _sliceMeridians = makeMeshSlicePoints(&(_geo));
    
//    deleteGeodesicSphere(&_geo);
//    deleteMeshTriangles(&_mesh);
//    _geo = octahedronSphere(_frequency);
//    _mesh = makeMeshTriangles(&_geo, 0.85);
}

@end
