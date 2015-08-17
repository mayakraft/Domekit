//
//  EquidistantAzimuthView.h
//  Domekit
//
//  Created by Robby on 5/17/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeodesicModel.h"

#define defaultLineWidth 12
#define defaultScale 28

@interface EquidistantAzimuthView : UIView

@property (nonatomic, weak) GeodesicModel *geodesic;

// these both get default values, from the macros, or you can set them yourself
@property (nonatomic) double scale;
@property (nonatomic) double lineWidth;

// colorTable is an array of UIColors, at least one is required
@property (weak) NSArray *colorTable;

// array of indices, corresponding to array indices in
// geodesic.lines and geodesic.points
@property NSSet *visiblePointIndices;
@property NSSet *visibleLineIndices;


-(void) drawProjectionWithContext:(CGContextRef)context inRect:(CGRect)rect;

@end
