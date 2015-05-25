//
//  DiagramViewController.h
//  Domekit
//
//  Created by Robby on 5/10/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeodesicModel.h"

@interface DiagramViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) GeodesicModel *geodesicModel;

// collection of (NSArray) keys: lines, lineTypes, lineQuantities,
@property (nonatomic, strong) NSDictionary *materials;

@property UITableView *tableView;

@property float scale;

@end
