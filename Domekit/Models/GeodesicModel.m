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
@property geodesicDome geo;
@property geodesicMeshTriangles mesh;
//@property geodesicMeshCropPlanes meridiansMesh;
//@property geodesicMeshSlicePoints sliceMeridians;
@end

@implementation GeodesicModel

-(id) initWithFrequency:(unsigned int)frequency Solid:(PolyhedronSeed)solid{
    if(!frequency)
        return nil;
    self = [super init];
    if(self){
        _frequency = frequency;
        _solid = solid;
        if(solid == ICOSAHEDRON_SEED)
            _geo = icosahedronDome(_frequency, 1.0);
        else if(solid == OCTAHEDRON_SEED)
            _geo = octahedronDome(_frequency, 1.0);
        _mesh = makeMeshTriangles(&(_geo.sphere), 0.85);
//        _sliceMeridians = makeMeshSlicePoints(&(_geo));
//        _meridiansMesh = makeMeshCropPlanes(&(_geo));
        _frequencyDenominator = _geo.numMeridians;
        _frequencyNumerator = _frequencyDenominator;
        _points = _geo.sphere.points;
        _lines = _geo.sphere.lines;
        _numPoints = _geo.sphere.numPoints;
        _numLines = _geo.sphere.numLines;
        [self resliceSphere];
    }
    return self;
}
-(id) initWithFrequency:(unsigned int)frequency Solid:(PolyhedronSeed)solid Crop:(unsigned int)numerator{
    if(!frequency || !numerator)
        return nil;
    self = [super init];
    if(self){
        _frequency = frequency;
        _solid = solid;
        if(solid == ICOSAHEDRON_SEED)
            _geo = icosahedronDome(_frequency, 1.0);
        else if(solid == OCTAHEDRON_SEED)
            _geo = octahedronDome(_frequency, 1.0);
        _mesh = makeMeshTriangles(&(_geo.sphere), 0.85);
        _frequencyDenominator = _geo.numMeridians;
        if(numerator > _frequencyDenominator)
            numerator = _frequencyDenominator;
        _frequencyNumerator = numerator;
        _points = _geo.sphere.points;
        _lines = _geo.sphere.lines;
        _numPoints = _geo.sphere.numPoints;
        _numLines = _geo.sphere.numLines;
        [self resliceSphere];
    }
    return self;
}
-(id) initWithFrequency:(unsigned int)frequency{
    return [self initWithFrequency:frequency Solid:0];
}
-(id) init{
    return [self initWithFrequency:1 Solid:0];
}

-(void) setSolid:(PolyhedronSeed)solid{
    _solid = solid;
    [self rebuildPolyhedra];
}
-(void) setFrequency:(unsigned int)frequency{
    if(!frequency)
        return;
    _frequency = frequency;
    [self rebuildPolyhedra];
}
-(void) setFrequencyNumerator:(unsigned int)frequencyNumerator{
    if(!frequencyNumerator)
        return;
    if(frequencyNumerator > _frequencyDenominator)
        frequencyNumerator = _frequencyDenominator;
    _frequencyNumerator = frequencyNumerator;
    [self resliceSphere];
}
-(void) setSphere{
    _frequencyNumerator = _frequencyDenominator;
    [self resliceSphere];
}
-(void) resliceSphere{
    _domeFraction = (float)_frequencyNumerator / (float)_frequencyDenominator;
    _domeFloorDiameter = sqrt(1 - pow(2*_domeFraction-1, 2));
    _domeHeight = sin((_domeFraction-.5)*M_PI)*.5 + .5;
    _longestStrutLength = 0;
    _numVisibleTriangles = [[self faceAltitudeCountsCumulative][_frequencyNumerator - 1] unsignedIntValue];
//    NSArray *sliceCounts = [self faceAltitudeCountsCumulative];
//    int unit = sender.value * (sliceCounts.count - 1);
//    if(unit+1 >= sliceCounts.count){
//        unit = (int)sliceCounts.count - 1;
//        [geodesicView setSliceAmount:0];
//        [self updateTitle];
//        return;
//    }
//    [geodesicView setSliceAmount:];
//    [self updateTitleWithFraction:unit+1 Of:(int)sliceCounts.count];
}

-(void) rebuildPolyhedra{
//    if(_solid == TETRAHEDRON_SEED)
//        [self makeTetrahedron];
    if(_solid == OCTAHEDRON_SEED)
        [self makeOctahedron];
    else
        [self makeIcosahedron];

    [self resliceSphere];
//    [self logGeodesic];
}

-(void) calculateLongestStrutLength
{
    double distance;
    double longest = 0;
    NSSet *lines = [NSSet setWithArray:[[self visiblePointsAndLines] objectForKey:@"lines"]];
    for(int i = 0; i < _numLines; i+=2)
    {
        if([lines containsObject:@(i)])
        {
            distance = sqrt(
                           powf( _points[_lines[i*2+0]* 3+0] - _points[_lines[i*2+1]* 3+0], 2) +
                           powf( _points[_lines[i*2+0]* 3+1] - _points[_lines[i*2+1]* 3+1], 2) +
                           powf( _points[_lines[i*2+0]* 3+2] - _points[_lines[i*2+1]* 3+2], 2) );
            
            if(longest < distance)
                longest = distance;
        }
    }
    // length = ratio to dome diameter, which is 1
    _longestStrutLength = longest * .5;  // (2 * 1.90211)
}

-(NSDictionary*)visiblePointsAndLines{
    NSMutableSet *pointIndices = [NSMutableSet set];
    NSMutableSet *lineIndices = [NSMutableSet set];
    for(int i = 0; i < _numVisibleTriangles; i++){
        [pointIndices addObject:@(_geo.sphere.faces[i*3+0])];
        [pointIndices addObject:@(_geo.sphere.faces[i*3+1])];
        [pointIndices addObject:@(_geo.sphere.faces[i*3+2])];
    }
    for(int i = 0; i < _geo.sphere.numLines; i++){
        NSNumber *pt1 = @(_geo.sphere.lines[i*2+0]);
        NSNumber *pt2 = @(_geo.sphere.lines[i*2+1]);
        if([pointIndices containsObject:pt1] && [pointIndices containsObject:pt2]){
            [lineIndices addObject:@(i)];
        }
    }
    return @{@"points" : [pointIndices allObjects], @"lines" : [lineIndices allObjects]};
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
    geodesicAnalysis a = classifyLines(&_geo.sphere);
    
    NSDictionary *visible = [self visiblePointsAndLines];
    NSSet *visibleLines = [NSSet setWithArray:[visible objectForKey:@"lines"]];
    NSSet *visiblePoints = [NSSet setWithArray:[visible objectForKey:@"points"]];
    
    NSMutableArray *types = [NSMutableArray array];
    for(int i = 0; i < _geo.sphere.numLines; i++){
        [types addObject:[NSNumber numberWithUnsignedInt:a.lineLengthTypes[i]]];
    }

    NSMutableArray *values = [NSMutableArray array];
    for(int i = 0; i < a.numLineLengths; i++)
        [values addObject:[NSNumber numberWithDouble:a.lineLengthValues[i]]];

//    NSMutableArray *quantites = [NSMutableArray array];
//    for(int i = 0; i < a.numLineLengths; i++)
//        [quantites addObject:[NSNumber numberWithUnsignedInt:a.lineTypesQuantities[i]]];

    
    unsigned int *lineTypesQuantities = calloc(sizeof(unsigned int), _numLines);
    for(int i = 0; i < _numLines; i++){
        if([visibleLines containsObject:@(i)])
            lineTypesQuantities[[types[i] intValue]]++;
    }
    NSMutableArray *quantites = [NSMutableArray array];
    for(int i = 0; i < _numLines; i++)
        [quantites addObject:[NSNumber numberWithUnsignedInt:lineTypesQuantities[i]]];
    
    free(lineTypesQuantities);
    
    _lineLengthTypes = types;
    _lineLengthValues = values;
    _lineTypeQuantities = quantites;
    
    _joints = @[@([visiblePoints count])];
    
//    NSLog(@"+ + + + + ++ + + + + + + + + ");
//    NSLog(@"types: %ld",_lineLengthTypes.count);
//    NSLog(@"values (%ld): %@",_lineLengthValues.count, _lineLengthValues);
//    NSLog(@"quantities (%ld): %@",_lineTypeQuantities.count, _lineTypeQuantities);
}

-(void) logGeodesic{
    if(_solid == 2)
        NSLog(@"new %dV tetrahedral geodesic", _frequency);
    else if(_solid == 1)
        NSLog(@"new %dV octahedral geodesic", _frequency);
    else
        NSLog(@"new %dV icosahedral geodesic", _frequency);
    NSLog(@"Sliced: %d / %d", _frequencyNumerator, _frequencyDenominator);
    NSLog(@" - points: %d", _geo.sphere.numPoints);
    NSLog(@" - lines: %d", _geo.sphere.numLines);
    NSLog(@" - faces: %d", _geo.sphere.numFaces);
//    NSLog(@" - meridians: %d", _geo.numMeridians);
}

-(void) drawTriangles{
    glPushMatrix();
    glRotatef(-90, 0, 0, 1);
    glScalef(_mesh.shrink, _mesh.shrink, _mesh.shrink);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, _mesh.glTriangles);
    glNormalPointer(GL_FLOAT, 0, _mesh.glTriangleNormals);
//    glDrawArrays(GL_TRIANGLES, 0, _geodesicModel.mesh.numTriangles*3);
    glDrawArrays(GL_TRIANGLES, 0, _numVisibleTriangles*3);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
}

-(void) drawTrianglesSphereOverride{
    glPushMatrix();
    glRotatef(-90, 0, 0, 1);
    glScalef(_mesh.shrink, _mesh.shrink, _mesh.shrink);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, _mesh.glTriangles);
    glNormalPointer(GL_FLOAT, 0, _mesh.glTriangleNormals);
    glDrawArrays(GL_TRIANGLES, 0, _mesh.numTriangles*3);
//    glDrawArrays(GL_TRIANGLES, 0, _visibleTriangles*3);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
}

-(void) drawHiddenTriangles{
    glCullFace(GL_BACK);
    [self drawTriangles];
    glCullFace(GL_FRONT);
}

-(void) drawHiddenTrianglesSphereOverride{
    glCullFace(GL_BACK);
    [self drawTrianglesSphereOverride];
    glCullFace(GL_FRONT);
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
//    deleteSlicePoints(&_sliceMeridians);
//    deleteCropPlanes(&_meridiansMesh);
    _geo = icosahedronDome(_frequency, 1.0);
    _mesh = makeMeshTriangles(&(_geo.sphere), 0.85);
//    _sliceMeridians = makeMeshSlicePoints(&(_geo));
//    _meridiansMesh = makeMeshCropPlanes(&(_geo));
    _frequencyDenominator = _geo.numMeridians;
    _frequencyNumerator = _frequencyDenominator;
    _points = _geo.sphere.points;
    _lines = _geo.sphere.lines;
    _numPoints = _geo.sphere.numPoints;
    _numLines = _geo.sphere.numLines;
    
//    deleteGeodesicSphere(&_geo);
//    deleteMeshTriangles(&_mesh);
//    _geo = icosahedronSphere(_frequency);
//    _mesh = makeMeshTriangles(&_geo, 0.85);
}

-(void)makeOctahedron{
    deleteGeodesicDome(&_geo);
    deleteMeshTriangles(&_mesh);
//    deleteSlicePoints(&_sliceMeridians);
//    deleteCropPlanes(&_meridiansMesh);
    _geo = octahedronDome(_frequency, 1.0);
    _mesh = makeMeshTriangles(&(_geo.sphere), 0.85);
//    _meridiansMesh = makeMeshCropPlanes(&(_geo.sphere));
//    _sliceMeridians = makeMeshSlicePoints(&(_geo));
    _frequencyDenominator = _geo.numMeridians;
    _frequencyNumerator = _frequencyDenominator;
    _points = _geo.sphere.points;
    _lines = _geo.sphere.lines;
    _numPoints = _geo.sphere.numPoints;
    _numLines = _geo.sphere.numLines;
    
//    deleteGeodesicSphere(&_geo);
//    deleteMeshTriangles(&_mesh);
//    _geo = octahedronSphere(_frequency);
//    _mesh = makeMeshTriangles(&_geo, 0.85);
}

@end
