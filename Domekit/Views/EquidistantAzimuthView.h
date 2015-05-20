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

@property (nonatomic) double scale;
@property (nonatomic) double lineWidth;

@property (weak) NSArray *colorTable;

@end
