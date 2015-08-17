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

// power function, never drops below 1.0
// so, when actually used, always delivered with (- 1.0) appended
@property float sessionScale;

// animations running
@property NSArray *animations;

-(void) updateUI;

-(void) storeCurrentDome;
-(void) loadDome:(NSDictionary*)dome;


// ALL THIS FOR THE KEYBOARD INPUT OF SCALE
-(void) iOSKeyboardShow;
-(void) iOSKeyboardHide;
-(void) userInputHeight:(float)value;
-(void) userInputFloorDiameter:(float)value;
-(void) userInputLongestStrut:(float)value;

@end

