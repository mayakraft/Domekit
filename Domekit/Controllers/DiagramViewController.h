//
//  DiagramViewController.h
//  Domekit
//
//  Created by Robby on 5/10/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeodesicModel.h"

@interface DiagramViewController : UIViewController

@property (nonatomic, weak) GeodesicModel *geodesicModel;

-(NSArray*) getLengthOrder;

@end
