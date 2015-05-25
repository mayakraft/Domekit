/**
 * @class Geodesic
 * @author Robby Kraft
 * @date 7/1/14
 *
 * @availability all
 *
 * @discussion Geodesic spheres and sphere slicing into geodesic domes. requires C-language geodesic geometry struct github.com/robbykraft/Geodesic
 */

//
// stores all modifications to the sphere too. dome slicing. and drawing of the sliced dome
//

#import <Foundation/Foundation.h>
#include "OpenGL/mesh.h"

typedef enum : NSUInteger {
    ICOSAHEDRON_SEED,
    OCTAHEDRON_SEED,
    TETRAHEDRON_SEED,
} PolyhedronSeed;

@interface GeodesicModel : NSObject

-(id) initWithFrequency:(unsigned int)frequency;  // assumes an icosahedron
-(id) initWithFrequency:(unsigned int)frequency Solid:(PolyhedronSeed)solid;
-(id) initWithFrequency:(unsigned int)frequency Solid:(PolyhedronSeed)solid Crop:(unsigned int)numerator;

@property (nonatomic) unsigned int frequency;
@property (nonatomic) PolyhedronSeed solid; // 0:icosahedron  1:octahedron  2:tetrahedron

// Crop Sphere:
// 0.0-1.0, or numerator of the frequencyDenominator
@property (nonatomic) unsigned int frequencyNumerator; // when this equals frequencyDenominator, the fraction is 1/1, which equals complete sphere
// how many rows of triangle meridians does this have?
@property (readonly) unsigned int frequencyDenominator;
@property (readonly) float domeFraction; // 1 (sphere), .5 (half dome), 0 (nothing left)
@property (readonly) unsigned int numVisibleTriangles;
@property (readonly) float domeFloorDiameter;  // floor diameter (0 to 1) according to slice location
@property (readonly) float domeHeight;  // floor height (0 to 1) according to slice location
@property (readonly) float longestStrutLength;  // as a ratio of domeFloorDiameter and domeHeight

-(void) calculateLongestStrutLength;

// RESET ALL SLICING, return to sphere
-(void) setSphere;

// for measuring out real-world scale: this number is the radius of the sphere
// does not change the geometry. does not affect any other numbers.
// just remembers a number. pretty pointless i suppose
@property float scale;

@property (nonatomic) NSArray *slicePoints;
@property (nonatomic) NSArray *faceAltitudeCountsCumulative;

-(void) makeLineClasses;  // fill these three arrays below, THEY WILL BE EMPTY OTHERWISE
@property (nonatomic) NSArray *lineLengthValues;
@property (nonatomic) NSArray *lineLengthTypes;
@property (nonatomic) NSArray *lineTypeQuantities;
@property NSArray *joints;

// not actual point, line data
// just indices to point and line indices in the original geodesic object
-(NSDictionary*)visiblePointsAndLines;  // builds in real time

// OpenGL
-(void) drawTriangles;
-(void) drawTrianglesSphereOverride;
// EXPOSE SOME OF THE DATA
@property float *points;
@property unsigned short *lines;
@property unsigned int numPoints;
@property unsigned int numLines;

@end
