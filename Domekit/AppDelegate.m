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

-(void) checkNSUserDefaults{
    BOOL flagSwitched = false;
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"units"]){
        flagSwitched = true;
        [[NSUserDefaults standardUserDefaults] setObject:@"feet + inches" forKey:@"units"];
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"]){
        flagSwitched = true;
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"gyro"];
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"precision"]){
        flagSwitched = true;
        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"precision"];
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"saved"]){
        flagSwitched = true;
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"saved"];
    }
    
    if(flagSwitched)
        [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*) unitifyNumber:(double)f{
    int precision = [[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] intValue];
    //    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@1])
    //    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@1])
    //    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@1])
    //    else
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"feet"]){
        if(precision == 1)
            return [NSString stringWithFormat:@"%.1f ft", f];
        else if(precision == 2)
            return [NSString stringWithFormat:@"%.3f ft", f];
        else if(precision == 3)
            return [NSString stringWithFormat:@"%.5f ft", f];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"feet + inches"]){
        int whole = floorf(f);
        double fraction = f - whole;
        double inches = fraction * 12;
        if(whole == 0){
            if(precision == 1)
                return [NSString stringWithFormat:@"%.1f in", inches];
            else if(precision == 2)
                return [NSString stringWithFormat:@"%.2f in", inches];
            else if(precision == 3)
                return [NSString stringWithFormat:@"%.4f in", inches];
        }
        if(precision == 1)
            return [NSString stringWithFormat:@"%d ft %.0f in", whole, inches];
        else if(precision == 2)
            return [NSString stringWithFormat:@"%d ft %.2f in", whole, inches];
        else if(precision == 3)
            return [NSString stringWithFormat:@"%d ft %.4f in", whole, inches];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"meters"]){
        if(precision == 1)
            return [NSString stringWithFormat:@"%.1f m", f];
        else if(precision == 2)
            return [NSString stringWithFormat:@"%.3f m", f];
        else if(precision == 3)
            return [NSString stringWithFormat:@"%.5f m", f];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"meters + centimeters"]){
        int whole = floorf(f);
        double fraction = f - whole;
        double centimeters = fraction * 100;
        if(whole == 0){
            if(precision == 1)
                return [NSString stringWithFormat:@"%.1f cm", centimeters];
            else if(precision == 2)
                return [NSString stringWithFormat:@"%.2f cm", centimeters];
            else if(precision == 3)
                return [NSString stringWithFormat:@"%.5f cm", centimeters];
        }
        if(precision == 1)
            return [NSString stringWithFormat:@"%d m %.0f cm", whole, centimeters];
        else if(precision == 2)
            return [NSString stringWithFormat:@"%d m %.2f cm", whole, centimeters];
        else if(precision == 3)
            return [NSString stringWithFormat:@"%d m %.4f cm", whole, centimeters];
    }
    return [NSString stringWithFormat:@"%f",f];
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
    [_geodesicViewController updateUI];
    [[(UITableViewController*)[_revealController rearViewController] tableView] reloadData];
    UITableView *tableView = [(UITableViewController*)[_revealController rearViewController] tableView];
    if (tableView.contentSize.height < tableView.frame.size.height) {
        tableView.scrollEnabled = NO;
    }
    else {
        tableView.scrollEnabled = YES;
    }
}

-(void) storeCurrentDome{
    [_geodesicViewController storeCurrentDome];
}
-(void) loadDome:(NSDictionary *)dome{
    [_geodesicViewController loadDome:dome];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.    
    
    // important for first runtime.
    [self checkNSUserDefaults];
    
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
