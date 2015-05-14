//
//  ViewController.h
//  Domekit
//
//  Created by Robby on 5/3/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController

-(id) initWithPolyhedra:(unsigned int)solidType;

@property (nonatomic) unsigned int solidType;

@end

