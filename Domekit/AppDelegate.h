//
//  AppDelegate.h
//  Domekit
//
//  Created by Robby on 5/3/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) newIcosahedron;
-(void) newOctahedron;

-(void) openPreferences;

-(void) updateUserPreferencesAcrossApp;

@end

