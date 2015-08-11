//
//  RearTableViewController.h
//  Social
//
//  Created by Robby on 12/15/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>

// not a subclass of UITableViewController, needed to alter the frame of self.tableView
@interface RearTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSIndexPath *lastSelection;

@property UITableView *tableView;

@end
