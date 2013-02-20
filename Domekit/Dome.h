//
//  Dome.h
//  Domekit
//
//  Created by Robby on 1/28/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point3D.h"

@interface Dome : NSObject
{
    NSArray *points_; // (Points3D) dome vertices (first 12 will always be original Icosahedron skeleton)
    NSArray *lines_;  // (int) pairs of index locations in points_ which are connected to each other
    NSArray *faces_;  // (int) triplets of indexes in points_ comprising a triangle
    
    NSArray *invisiblePoints_;  // everywhere points_ grows, so must this
    NSArray *invisibleLines_;   // everywhere lines_ grows, so must this
    
    NSArray *lineClass_;  //   category of lines by class
    NSArray *lineClassLengths_;  //  lengths of each category of lines
    int v;
    BOOL icosahedron; // 1 = icosa, 0 = octa
}

@property NSArray *points_;
@property NSArray *lines_;
@property NSArray *faces_;
@property NSArray *invisiblePoints_;
@property NSArray *invisibleLines_;
@property NSArray *lineClass_;
@property NSArray *lineClassLengths_;
@property int v;

-(id) init;
-(id) initWithDome:(Dome*) input;
-(void) geodecise:(int)v;
-(void) classifyLines;
-(void) setIcosahedron;
-(void) setOctahedron;

@end
