//
//  Dome - a geodesic sphere object
//
//  Dome object maintains:
//   all the geometry of a dome sphere
//   and all the properties of each point and line
//   even which ones are hidden and visible after cropping
//   but does not go as far as to ignore 
//   - geometry of dome sphere
//   - which lines are removed to make sphere into dome
//
//   points_   .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
//   lines_  array of points ..  ..  ..  ..  ..  ..  ..  ..  ..  ..
//   faces_  array of points ...  ...  ...  ...  ...  ...  ...
//   lineClass_ mirror array of lines_, values are 1, 2, 3 (which group each belongs to)
//   - hidden lines and points which lie below ground level

#import "Dome.h"

@implementation Dome
@synthesize points_;
@synthesize lines_;
@synthesize faces_;
@synthesize invisibleLines_;
@synthesize invisiblePoints_;
@synthesize lineClass_;
@synthesize lineClassLengths_;
@synthesize v;

-(id) init
{
    [self loadIcosahedron];
    icosahedron = true;
    NSMutableArray *lineClass = [[NSMutableArray alloc] init];
    NSMutableArray *lineClassLengths = [[NSMutableArray alloc] init];
    NSMutableArray *invisiblePoints = [[NSMutableArray alloc] init];
    NSMutableArray *invisibleLines = [[NSMutableArray alloc] init];
    int i;
    for(i = 0; i < points_.count; i++) [invisiblePoints addObject:[[NSNumber alloc] initWithBool:FALSE]];
    for(i = 0; i < lines_.count; i++) [invisibleLines addObject:[[NSNumber alloc] initWithBool:FALSE]];
    for(i = 0; i < lines_.count/2; i++) {
        [lineClass addObject:[[NSNumber alloc] initWithInt:0]];
    }
    [lineClassLengths addObject:[[NSNumber alloc] initWithDouble:2.0]];
    invisiblePoints_ = [[NSArray alloc] initWithArray:invisiblePoints];
    invisibleLines_ = [[NSArray alloc] initWithArray:invisibleLines];
    lineClass_ = [[NSArray alloc] initWithArray:lineClass];
    lineClassLengths_ = [[NSArray alloc] initWithArray:lineClassLengths];
    v = 1;
    return self;
}

-(id) initWithDome:(Dome*) input
{
    points_ = [[NSArray alloc] initWithArray:input.points_];
    lines_ = [[NSArray alloc] initWithArray:input.lines_];
    faces_ = [[NSArray alloc] initWithArray:input.faces_];
    invisiblePoints_ = [[NSArray alloc] initWithArray:input.invisiblePoints_];
    invisibleLines_ = [[NSArray alloc] initWithArray:input.invisibleLines_];
    lineClass_ = [[NSArray alloc] initWithArray:input.lineClass_];
    lineClassLengths_ = [[NSArray alloc] initWithArray:input.lineClassLengths_];
    v = input.v;
    return self;
}

-(void) setIcosahedron {icosahedron = true;}

-(void) setOctahedron {icosahedron = false;}

-(void) classifyLines
{
    //NSLog(@"ClassifyLines");
    int i, j;
    unsigned int rounded;
    double distance;
    bool found;
    unsigned int elbow = 100000000;
    double nudge = .00000000001;
    NSMutableArray *lengths = [[NSMutableArray alloc] init];
    NSMutableArray *lineClass = [[NSMutableArray alloc] init];
    NSMutableArray *originalLengths = [[NSMutableArray alloc] init];
    
    for(i = 0; i < lines_.count; i+=2)
    {
        distance = sqrt(pow([points_[ [lines_[i] integerValue] ] getX] - [points_[ [lines_[i+1] integerValue] ] getX],2)
                      + pow([points_[ [lines_[i] integerValue] ] getY] - [points_[ [lines_[i+1] integerValue] ] getY],2)
                      + pow([points_[ [lines_[i] integerValue] ] getZ] - [points_[ [lines_[i+1] integerValue] ] getZ],2));
        rounded = floor((distance+nudge)*elbow);
        if(i == 0){
            [lineClass addObject:[[NSNumber alloc] initWithInt:i]];
            [lengths addObject:[[NSNumber alloc] initWithUnsignedInt:rounded]];
            [originalLengths addObject:[[NSNumber alloc] initWithDouble:distance]];
            //NSLog(@"O:%.21g ->%d",distance,i);
        }
        else{
            found = false;
            for(j = 0; j < lengths.count; j++)
            {
                if(!found && rounded == [lengths[j] integerValue]){
                    found = true;
                    [lineClass addObject:[[NSNumber alloc] initWithInt:j]];
                    //NSLog(@"O:%.21g ->%d",distance,j);
                }
            }
            if(!found){
                [lineClass addObject:[[NSNumber alloc] initWithInt:j]];
                [lengths addObject:[[NSNumber alloc] initWithUnsignedInt:rounded]];
                [originalLengths addObject:[[NSNumber alloc] initWithDouble:distance]];
                //NSLog(@"O:%.21g ->%d",distance,j);
            }
        }
    }
//    NSLog(@"%d, %d", lineClass.count, lines_.count);
    lineClass_ = [[NSArray alloc] initWithArray:lineClass];
    lineClassLengths_ = [[NSArray alloc] initWithArray:originalLengths];
    //for(i=0; i < lineClass_.count; i++) NSLog(@"%d", [lineClass_[i] integerValue]);
}

-(void) geodecise:(int)vNum
{
    if(icosahedron)[self loadIcosahedron];
    else [self loadOctahedron];
    [self divideFaces:vNum];
    [self spherize];
    if(vNum!=1)[self connectTheDots];
    [self classifyLines];
}

-(void) divideFaces:(int)vNum
{
    v = vNum;
    if(v > 1)
    {
        //NSLog(@"DivideFaces");
        NSMutableArray *points = [[NSMutableArray alloc] initWithArray:points_];
        int i, j, k;//, counter = 0;
        Point3D *pointA = [[Point3D alloc] init];
        Point3D *pointB = [[Point3D alloc] init];
        Point3D *pointC = [[Point3D alloc] init];
        double xAB, xAC, yAB, yAC, zAB, zAC;
        for(i=0; i < faces_.count; i+=3)
        {
            pointA = points_[[faces_[i] integerValue]];
            pointB = points_[[faces_[i+1] integerValue]];
            pointC = points_[[faces_[i+2] integerValue]];
            
            xAB = ( [pointB getX] - [pointA getX] ) / (double)v;
            yAB = ( [pointB getY] - [pointA getY] ) / (double)v;
            zAB = ( [pointB getZ] - [pointA getZ] ) / (double)v;
            xAC = ( [pointC getX] - [pointA getX] ) / (double)v;
            yAC = ( [pointC getY] - [pointA getY] ) / (double)v;
            zAC = ( [pointC getZ] - [pointA getZ] ) / (double)v;
            
            for(j = 0; j <= v; j++)
            {
                for(k = 0; k <= v - j; k++)
                {
                    if(!((j == 0 && k == 0) || (j == 0 & k == v) || (j == v && k == v)))
                    {
                        [points addObject:[[Point3D alloc]
                            initWithCoordinatesX:[pointA getX] + j * xAB + k * xAC
                                               Y:[pointA getY] + j * yAB + k * yAC
                                               Z:[pointA getZ] + j * zAB + k * zAC]];
                    }
                }
            }
        }
        points_ = [[NSArray alloc] initWithArray:points];
        [self removeDuplicatePoints];
    }
}

-(void) spherize
{
    int i;
    double difference, distance;
    double maxdistance = 0;
    NSMutableArray *points = [[NSMutableArray alloc] init];
    /*for(i = 0; i < points_.count; i++){
        distance = sqrt(pow([points_[i] getX], 2) + pow([points_[i] getY], 2) + pow([points_[i] getZ], 2) );
        if(distance > maxdistance) maxdistance = distance;
    }*/
    // never mind, i already know the max distance
    maxdistance = sqrt( ((1 + sqrt(5)) / 2 ) + 2 );
    for(i = 0; i < points_.count; i++)
    {
        distance = sqrt(pow([points_[i] getX], 2) +
                        pow([points_[i] getY], 2) +
                        pow([points_[i] getZ], 2) );
        difference = maxdistance / distance;
        [points addObject:[[Point3D alloc] initWithCoordinatesX:[points_[i] getX]*difference
                                                              Y:[points_[i] getY]*difference
                                                              Z:[points_[i] getZ]*difference]];
    }
    points_ = [[NSArray alloc] initWithArray:points];
}

-(void) connectTheDots
{
    // Calibrated for Regular Domes
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    int i, j;
    double elbow = .0000002;
    double distanceSquared, shortest, ceiling;
    bool firstRun;
    for(i = 0; i < 1; i++)  // Shortcut for regular dome
    {
        firstRun = true;
        for(j=0; j < points_.count; j++)
        {
            if(j != i)
            {
                distanceSquared= pow( [points_[j] getX] - [points_[i] getX], 2) +
                                 pow( [points_[j] getY] - [points_[i] getY], 2) +
                                 pow( [points_[j] getZ] - [points_[i] getZ], 2);
                if(firstRun){
                    shortest = distanceSquared;
                    firstRun = false;
                }
                else{
                    if(distanceSquared+elbow < shortest) shortest = distanceSquared;
                }
            }
        }
    }
    if(!icosahedron) ceiling = shortest * 3.4;
    else ceiling = shortest * 2.5;  //1.5 if using Distance, not DistanceSquared
    //all further line segments will be based on this shortest value:
    for(i = 0; i < points_.count; i++)
    {
        for(j=0; j < points_.count; j++)
        {
            if(j != i)
            {
                distanceSquared = pow( [points_[j] getX] - [points_[i] getX], 2) +
                                  pow( [points_[j] getY] - [points_[i] getY], 2) +
                                  pow( [points_[j] getZ] - [points_[i] getZ], 2);
                if(distanceSquared < ceiling)
                {
                    [lines addObjectsFromArray:[[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:i],
                                                                                [[NSNumber alloc] initWithInt:j],
                                                                                nil]];
                }
            }
        }
    }
    lines_ = [[NSArray alloc] initWithArray:lines];
    [self removeDuplicateLines];
}

-(void) removeDuplicateLines
{
    //Unwrapping NSNumbers is slow as fuck. first step = convert to C array
    NSMutableArray *lines = [[NSMutableArray alloc] initWithArray:lines_];
    int linesC[lines_.count];
    int i, j, count = [lines count];
    bool duplicates[lines_.count];
    
    for(i = 0; i < lines_.count; i++)
    {
        linesC[i] = [lines_[i] integerValue];
        duplicates[i] = false;
    }
    for(i = 0; i < count; i+=2)
    {
        for(j = i+2; j < count; j+=2)
        {
            if ( (linesC[i] == linesC[j] && linesC[i+1] == linesC[j+1]) ||
                (linesC[i] == linesC[j+1] && linesC[i+1]== linesC[j] ) )
            {
                duplicates[j] = [[NSNumber alloc] initWithBool:true];
            }
        }
    }
    for(i=lines_.count-2; i >= 0; i-=2)
    {
        if(duplicates[i] == true)[lines removeObjectsInRange:NSMakeRange(i, 2)];
    }
    lines_ = [[NSArray alloc] initWithArray:lines];
}

-(void) removeDuplicatePoints
{
    NSMutableArray *duplicateIndexes = [[NSMutableArray alloc] init];
    NSMutableArray *points = [[NSMutableArray alloc] init];
    int i, j;
    bool found;
    double elbow = .00000000001;
    for(i = 0; i < points_.count - 1; i++)
    {
        for(j = i+1; j < points_.count; j++)
        {
            if ([points_[i] getX] - elbow < [points_[j] getX] && [points_[i] getX] + elbow > [points_[j] getX] &&
                [points_[i] getY] - elbow < [points_[j] getY] && [points_[i] getY] + elbow > [points_[j] getY] &&
                [points_[i] getZ] - elbow < [points_[j] getZ] && [points_[i] getZ] + elbow > [points_[j] getZ] )
            {
                //NSLog(@"Duplicates(X): %.21g %.21g",[points_[i] getX], [points_[j] getX]);
                [duplicateIndexes addObject:[[NSNumber alloc] initWithInt:j]];
            }
        }
    }
    for(i = 0; i < points_.count; i++)
    {
        found = false;
        for(j = 0; j < duplicateIndexes.count; j++){
            if(i == [duplicateIndexes[j] integerValue])
                found = true;
        }
        if(!found) [points addObject:points_[i]];
    }
    points_ = [[NSArray alloc] initWithArray:points];
}

-(void) loadOctahedron
{
    points_ = [[NSArray alloc] initWithObjects:
               [[Point3D alloc] initWithCoordinatesX:0 Y:1.9 Z:0],
               [[Point3D alloc] initWithCoordinatesX:1.9 Y:0 Z:0],
               [[Point3D alloc] initWithCoordinatesX:0 Y:0 Z:-1.9],
               
               [[Point3D alloc] initWithCoordinatesX:-1.9 Y:0 Z:0],
               [[Point3D alloc] initWithCoordinatesX:0 Y:0 Z:1.9],
               [[Point3D alloc] initWithCoordinatesX:0 Y:-1.9 Z:0], nil];
    
    lines_ = [[NSArray alloc] initWithObjects:
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:2],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:4],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:1],[[NSNumber alloc] initWithInt:2],
              [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:2],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:1],
              nil];
    
    faces_ = [[NSArray alloc] initWithObjects:
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:4],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:1],[[NSNumber alloc] initWithInt:2],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:1],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:4],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:2],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:1],
              nil];
}

-(void) loadIcosahedron
{
    double phi = (1 + sqrt(5)) / 2;
    points_ = [[NSArray alloc] initWithObjects:[[Point3D alloc] initWithCoordinatesX:0 Y:1 Z:phi],
                                               [[Point3D alloc] initWithCoordinatesX:0 Y:-1 Z:phi],
                                               [[Point3D alloc] initWithCoordinatesX:0 Y:-1 Z:-phi],
                                               [[Point3D alloc] initWithCoordinatesX:0 Y:1 Z:-phi],
               
                                               [[Point3D alloc] initWithCoordinatesX:phi Y:0 Z:1],
                                               [[Point3D alloc] initWithCoordinatesX:-phi Y:0 Z:1],
                                               [[Point3D alloc] initWithCoordinatesX:-phi Y:0 Z:-1],
                                               [[Point3D alloc] initWithCoordinatesX:phi Y:0 Z:-1],
               
                                               [[Point3D alloc] initWithCoordinatesX:1 Y:phi Z:0],
                                               [[Point3D alloc] initWithCoordinatesX:-1 Y:phi Z:0],
                                               [[Point3D alloc] initWithCoordinatesX:-1 Y:-phi Z:0],
                                               [[Point3D alloc] initWithCoordinatesX:1 Y:-phi Z:0], nil];
    
    lines_ = [[NSArray alloc] initWithObjects:
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:8],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:9],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:5],
              [[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:9],
              [[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:7],
              [[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:9],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:9],[[NSNumber alloc] initWithInt:6],
              [[NSNumber alloc] initWithInt:9],[[NSNumber alloc] initWithInt:5],
              [[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:2],
              [[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:11],
              [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:10],
              [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:11],
              [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:3],
              [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:6],
              [[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:11],
              [[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:5],
              [[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:6],
              [[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:11],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:11],[[NSNumber alloc] initWithInt:4],
              [[NSNumber alloc] initWithInt:4],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:1],
              [[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:6],
              [[NSNumber alloc] initWithInt:6],[[NSNumber alloc] initWithInt:3],
              nil];
    
    faces_ = [[NSArray alloc] initWithObjects:
            [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:9],
            [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:4],
            [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:9],[[NSNumber alloc] initWithInt:5],
            [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:1],[[NSNumber alloc] initWithInt:4],
            [[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:1],[[NSNumber alloc] initWithInt:5],
            [[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:9],
            [[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:7],
            [[NSNumber alloc] initWithInt:8],[[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:4],
            [[NSNumber alloc] initWithInt:9],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:6],
            [[NSNumber alloc] initWithInt:9],[[NSNumber alloc] initWithInt:6],[[NSNumber alloc] initWithInt:5],
            [[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:4],[[NSNumber alloc] initWithInt:11],
            [[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:2],
            [[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:11],
            [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:11],
            [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:6],
            [[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:6],
            [[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:11],[[NSNumber alloc] initWithInt:1],
            [[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:6],
            [[NSNumber alloc] initWithInt:10],[[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:1],
            [[NSNumber alloc] initWithInt:11],[[NSNumber alloc] initWithInt:1],[[NSNumber alloc] initWithInt:4],
            nil];

    [self alignIcosahedron];
}

-(void) alignIcosahedron
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    double offset =  (M_PI/2) - atan( (1 + sqrt(5)) / 2 );
    double distance, angle;
    for(int i = 0; i < points_.count; i++)
    {
        angle = atan2([points_[i] getX], [points_[i] getY]);
        distance = sqrt( pow([points_[i] getX], 2) + pow([points_[i] getY], 2) );
        [points addObject:[[Point3D alloc] initWithCoordinatesX:distance*sin(angle+offset)
                                                              Y:distance*cos(angle+offset)
                                                              Z:[points_[i] getZ]]];
    }
    points_ = [[NSArray alloc] initWithArray:points];
}

/*
-(void) generateFaces
{
    // trace every three-line segment paths, record all paths which are closed
    int i, j, k;
    BOOL found;
    NSNumber *first, *second, *third;   // an index to a Point3D in points_
    NSMutableArray *faces = [[NSMutableArray alloc] init];
    for(i=0;i < lines_.count; i+=2)
    {
        first = lines_[i];
        second = lines_[i+1];
        // search all paths to find another point which touches either *first or *second
        for(j=0; j < lines_.count; j+=2)
        {
            third = nil;
            if (lines_[j] == first && lines_[j+1] != second) third = lines_[j+1];
            else if(lines_[j+1] == first && lines_[j] != second) third = lines_[j];
            if(third != nil)
            {
                found = false;
                // search all paths again to confirm point touches both *first and *second
                for(k=0; k< lines_.count; k+=2)
                    if( (lines_[k] == third && lines_[k+1] == second) || (lines_[k] == second && lines_[k+1] == third) )
                        found = true;
                
                if(found) [faces addObjectsFromArray:[[NSArray alloc] initWithObjects:first, second, third, nil]];
            }
        }
    }
    
    // remove duplicates
    for (i = 0; i < faces.count; i+=3) {
        first = faces[i];
        second = faces[i+1];
        third = faces[i+2];
        for (j = 0; j < faces.count; j+=3) {
            if (j != i) {
                if ((first == faces[j] && second == faces[j+1] && third == faces[j+2]) ||
                    (second == faces[j] && first == faces[j+1] && third == faces[j+2]) ||
                    (first == faces[j] && third == faces[j+1] && second == faces[j+2]) ||
                    (second == faces[j] && third == faces[j+1] && first == faces[j+2]) ||
                    (third == faces[j] && first == faces[j+1] && second == faces[j+2]) ||
                    (third == faces[j] && second == faces[j+1] && first == faces[j+2]))
                {
                    [faces removeObjectsInRange:NSMakeRange(j, 3)];
                    j-=3;
                }
            }
        }
    }
    for(i=0; i < faces.count; i+=3) NSLog(@"%@ -- %@ -- %@", faces[i], faces[i+1], faces[i+2]);
    faces_ = [[NSArray alloc] initWithArray:faces];
}
*/
 
@end
