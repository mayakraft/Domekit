//
//  RearTableViewController.m
//  Social
//
//  Created by Robby on 12/15/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "RearTableViewController.h"
#import "SWRevealViewController.h"
#import "NewDomeTableViewCell.h"
#import "AppDelegate.h"

#define BLUE_COLOR [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]

#define MONTHS @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"]

@interface RearTableViewController () {
    NSInteger _previouslySelectedRow;
//    UIView *selectionView;
    NSInteger numberOfSavedDomes;
    UIButton *_deleteButton;
}

@end

@implementation RearTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 260, self.tableView.frame.size.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        self.tableView.scrollEnabled = NO;
    }
    else {
        self.tableView.scrollEnabled = YES;
    }
    
//    selectionView = [[UIView alloc] init];
//    [selectionView setBackgroundColor:[UIColor blueColor]];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) editSavedDomes:(id)sender{
    if([self.tableView isEditing]){
        [sender setTitle:@"EDIT" forState:UIControlStateNormal];
        [sender setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
    else{
        [sender setTitle:@"DONE" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 1;
    else if (section == 1)
        return 1 + [[[NSUserDefaults standardUserDefaults] objectForKey:@"saved"] count];
    else if(section == 2)
        return 1;
    else if(section == 3)
        return 1;
    else
        return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0)
        return 120;
    return 44;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, [[UIScreen mainScreen] bounds].size.width, 28)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [titleLabel setTextColor:[UIColor grayColor]];
    if(section == 0)
        [titleLabel setText:@"NEW DOME"];
    else if (section == 1)
        [titleLabel setText:@"SAVED DOMES"];
    else if(section == 2)
        [titleLabel setText:@"DOMEKIT"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40)];
    [view addSubview:titleLabel];
    
    if(section == 1){
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(88, 12, 100, 28)];
        [editButton setTitle:@"EDIT" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editSavedDomes:) forControlEvents:UIControlEventTouchUpInside];
        [editButton setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [editButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
        
        [view addSubview:editButton];
    }
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
        NewDomeTableViewCell *cell = [[NewDomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newDomeCell"];
        [[cell leftButton] addTarget:(AppDelegate*)[[UIApplication sharedApplication] delegate]  action:@selector(newIcosahedron) forControlEvents:UIControlEventTouchUpInside];
        [[cell rightButton] addTarget:(AppDelegate*)[[UIApplication sharedApplication] delegate]  action:@selector(newOctahedron) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section == 1 && indexPath.row != 0)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    else
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor whiteColor];
//    cell.selectedBackgroundView = selectionView;

    if(indexPath.section == 0){
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [cell.textLabel setText:@"+  Save Current Dome"];
            [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
        }
        else{
            NSArray *savedDomes = [[NSUserDefaults standardUserDefaults] objectForKey:@"saved"];
            NSDictionary *dome = [savedDomes objectAtIndex:indexPath.row-1];
            NSString *title;
            NSString *solid = @"";
            if([[dome objectForKey:@"solid"] isEqualToNumber:@0])
                solid = @"Icosahedron";
            else if([[dome objectForKey:@"solid"] isEqualToNumber:@1])
                solid = @"Octahedron";

            if([[dome objectForKey:@"numerator"] isEqualToNumber:[dome objectForKey:@"denominator"]]){
                title = [NSString stringWithFormat:@"%@V %@",[dome objectForKey:@"frequency"], solid ];
            }
            else{
                title = [NSString stringWithFormat:@"%@V %@/%@ %@", [dome objectForKey:@"frequency"], [dome objectForKey:@"numerator"], [dome objectForKey:@"denominator"], solid];
            }
            if([dome objectForKey:@"date"]){
                NSDate *date = [dome objectForKey:@"date"];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
                NSString *timeString;
                int hour = (int)[components hour];
                NSString *meridian = @"";
                if(hour > 12){
                    hour -= 12;
                    meridian = @" pm";
                }
                if(hour == 0)
                    hour += 12;
                if( ([components minute] < 10) )
                    timeString = [NSString stringWithFormat:@"%d:0%d",hour, (int)[components minute]];
                else
                    timeString = [NSString stringWithFormat:@"%d:%d",hour, (int)[components minute]];
                int monthIndex = ([components month]-1)%12;
                NSString *dateString = [NSString stringWithFormat:@"%@ %d, %d %@%@",MONTHS[monthIndex],(int)[components day], (int)[components year], timeString, meridian];
                [[cell detailTextLabel] setText:dateString];
                [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
            }
            [cell.textLabel setText:title];
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0)
            [cell.textLabel setText:@"Preferences"];
//        if(indexPath.row == 1)
//            [cell.textLabel setText:@"About Domes"];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == 0){
        if(indexPath.row == 0)
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] newIcosahedron];
        if(indexPath.row == 1)
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] newOctahedron];
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] storeCurrentDome];
        }
        else{
            NSArray *savedDomes = [[NSUserDefaults standardUserDefaults] objectForKey:@"saved"];
            NSDictionary *dome = [savedDomes objectAtIndex:indexPath.row-1];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] loadDome:dome];
            
            SWRevealViewController *revealController = [self revealViewController];
            [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateUserPreferencesAcrossApp];
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0)
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] openPreferences];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section == 1 && indexPath.row != 0)
        return YES;
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray *savedDomes = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saved"] mutableCopy];
        [savedDomes removeObjectAtIndex:indexPath.row-1];
        [[NSUserDefaults standardUserDefaults] setObject:savedDomes forKey:@"saved"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


@end
