//
//  AppDelegate.m
//  Domekit
//
//  Created by Robby on 5/3/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "AppDelegate.h"
#import "GeodesicViewController.h"
#import "SWRevealViewController.h"
#import "RearTableViewController.h"
#import "NavigationController.h"
#import "NavigationBar.h"
#import "PreferencesTableViewController.h"

@interface AppDelegate () <SWRevealViewControllerDelegate>
@property SWRevealViewController *revealController;
@property UINavigationController *geodesicNavigationController;
@property GeodesicViewController *geodesicViewController;
@end

@implementation AppDelegate

-(void) firstRunTime{
    [[NSUserDefaults standardUserDefaults] setObject:@"feet" forKey:@"units"];
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"gyro"];
    [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"precision"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) newIcosahedron{
    if(![[_revealController frontViewController] isEqual:_geodesicNavigationController])
        [_revealController setFrontViewController:_geodesicNavigationController];
    [_geodesicViewController newPolyhedra:0];
    [_revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
-(void) newOctahedron{
    if(![[_revealController frontViewController] isEqual:_geodesicNavigationController])
        [_revealController setFrontViewController:_geodesicNavigationController];
    [_geodesicViewController newPolyhedra:1];
    [_revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
//-(void) openPreferences{
//    UINavigationController *preferencesNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[NavigationBar class] toolbarClass:nil];
//    [preferencesNavigationController setViewControllers:@[[[PreferencesTableViewController alloc] initWithStyle:UITableViewStyleGrouped]]];
//    [_revealController setFrontViewController:preferencesNavigationController];
//    [_revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//}
-(void) openPreferences{
    PreferencesTableViewController *preferencesViewcontroller = [[PreferencesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [_geodesicViewController.navigationController pushViewController:preferencesViewcontroller animated:NO];
    [_revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}

-(void) updateUserPreferencesAcrossApp{
    BOOL enabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] boolValue];
    [_geodesicViewController setOrientationSensorsEnabled:enabled];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    // first runtime.
    // no preferences. make preferences for the first time.
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"units"]){
        [self firstRunTime];
    }
    
    _geodesicViewController = [[GeodesicViewController alloc] init];
    _geodesicNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[NavigationBar class] toolbarClass:nil];
    [_geodesicNavigationController setViewControllers:@[_geodesicViewController]];
    
    RearTableViewController *rearViewController = [[RearTableViewController alloc] initWithStyle:UITableViewStyleGrouped];

    _revealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:_geodesicNavigationController];
    _revealController.rearViewRevealWidth = 260;
    _revealController.rearViewRevealOverdraw = 120;
    _revealController.bounceBackOnOverdraw = NO;
    _revealController.stableDragOnOverdraw = YES;
    _revealController.delegate = self;
    [_revealController setFrontViewPosition:FrontViewPositionLeft];
    
    self.window.rootViewController = _revealController;
    [self.window makeKeyAndVisible];
    NSLog(@"++++++++++ %ld",(long)[_revealController frontViewPosition]);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
