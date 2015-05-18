//
//  DiagramViewController.h
//  Domekit
//
//  Created by Robby on 5/10/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "GeodesicModel.h"


#define defaultLineWidth 1
#define defaultScale 28


@interface DiagramViewController : GLKViewController

@property (nonatomic, weak) GeodesicModel *geodesicModel;

@property (nonatomic) double scale;
@property (nonatomic) double lineWidth;

-(NSArray*) getLengthOrder;

@end
