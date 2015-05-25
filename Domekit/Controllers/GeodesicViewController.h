//
//  ViewController.h
//  Domekit
//
//  Created by Robby on 5/3/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface GeodesicViewController : GLKViewController

-(id) initWithPolyhedra:(unsigned int)solidType;

@property (nonatomic) unsigned int solidType;

-(void) newPolyhedra:(unsigned int) solidType;

@property (nonatomic) BOOL orientationSensorsEnabled;

@property float sessionScale;

-(void) updateUI;

-(void) storeCurrentDome;
-(void) loadDome:(NSDictionary*)dome;

@end

