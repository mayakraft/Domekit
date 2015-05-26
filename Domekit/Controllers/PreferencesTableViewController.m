//
//  PreferencesTableViewController.m
//  Domekit
//
//  Created by Robby on 5/19/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "PreferencesTableViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "PreferencesTableViewCell.h"

@interface PreferencesTableViewController ()

@end

@implementation PreferencesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self initRevealController];
    
    [self setTitle:@"PREFERENCES"];
 
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;

    [[[self navigationController] navigationBar] setBarTintColor:[UIColor whiteColor]];
    [[[self navigationController] navigationBar] setBarStyle:UIBarStyleDefault];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setScrollEnabled:NO];
}
-(void) backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) initRevealController{
    SWRevealViewController *revealController = self.revealViewController;
    //    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    //TODO: this is not dynamically sized
    UIButton *revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22*3/2, 17*3/2)];
    [revealButton setBackgroundImage:[UIImage imageNamed:@"reveal-icon"] forState:UIControlStateNormal];
    [revealButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *revealBarButton = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
    [self.navigationItem setLeftBarButtonItem:revealBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
        return 3;
    else if(section == 1)
        return 2;
    else
        return 0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"";
    else if(section == 1)
        return @"Storage";
    else
        return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PreferencesTableViewCell *cell = [[PreferencesTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PreferencesTableViewCell"];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [[cell textLabel] setText:@"Units"];
            [[cell detailTextLabel] setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"units"]];
        }
        else if(indexPath.row == 1){
            [[cell textLabel] setText:@"Accelerometer/Gyro"];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] isEqualToNumber:@YES])
                [[cell detailTextLabel] setText:@"on"];
            else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] isEqualToNumber:@NO])
                [[cell detailTextLabel] setText:@"off"];
        }
        else if(indexPath.row == 2){
            [[cell textLabel] setText:@"Precision"];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@1])
                [[cell detailTextLabel] setText:@"elementary"];
            else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@2])
                [[cell detailTextLabel] setText:@"precise"];
            else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@3])
                [[cell detailTextLabel] setText:@"machine level"];
        }
    }
    else{
        if(indexPath.row == 0){
            NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"saved"];
            [[cell textLabel] setText:[NSString stringWithFormat:@"(%lu) Saved Domes", (unsigned long)[saved count]]];
        }
        if(indexPath.row == 1){
            [[cell textLabel] setText:@"Clear Saved Domes"];
            [cell setTextColor:[UIColor redColor]];
            [cell setTextAlignment:@1];
        }
    }
    return cell;
}

-(void) cycleUnits:(UITableViewCell*)cell{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"feet"] ||
       [[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"ft"] ||
       [[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"standard"] ){
        [[cell detailTextLabel] setText:@"feet + inches"];
        [[NSUserDefaults standardUserDefaults] setObject:@"feet + inches" forKey:@"units"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"feet + inches"] ||
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"ft + in"] ){
        [[cell detailTextLabel] setText:@"meters"];
        [[NSUserDefaults standardUserDefaults] setObject:@"meters" forKey:@"units"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"meters"] ||
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"m"] ||
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"metric"] ){
        [[cell detailTextLabel] setText:@"meters + centimeters"];
        [[NSUserDefaults standardUserDefaults] setObject:@"meters + centimeters" forKey:@"units"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"meters + centimeters"] ||
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"units"] isEqualToString:@"m + cm"]){
        [[cell detailTextLabel] setText:@"feet"];
        [[NSUserDefaults standardUserDefaults] setObject:@"feet" forKey:@"units"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void) togglePrecision:(UITableViewCell*)cell{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@2]){
        [[cell detailTextLabel] setText:@"machine level"];
        [[NSUserDefaults standardUserDefaults] setObject:@3 forKey:@"precision"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@3]){
        [[cell detailTextLabel] setText:@"elementary"];
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"precision"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"precision"] isEqualToNumber:@1]){
        [[cell detailTextLabel] setText:@"precise"];
        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"precision"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void) toggleGyro:(UITableViewCell*)cell{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] isEqualToNumber:@NO]){
        [[cell detailTextLabel] setText:@"on"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"gyro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] isEqualToNumber:@YES]){
        [[cell detailTextLabel] setText:@"off"];
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"gyro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self cycleUnits:cell];
        }
        if(indexPath.row == 1){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self toggleGyro:cell];
        }
        if(indexPath.row == 2){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self togglePrecision:cell];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 1){
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"saved"] count]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Erase", nil];
                [alert show];
            }
        }
    }
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateUserPreferencesAcrossApp];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"saved"];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateUserPreferencesAcrossApp];
        [self.tableView reloadData];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
