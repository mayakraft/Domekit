//
//  RearTableViewController.m
//  Social
//
//  Created by Robby on 12/15/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "RearTableViewController.h"
#import "SWRevealViewController.h"

#import "AppDelegate.h"

@interface RearTableViewController () {
    NSInteger _previouslySelectedRow;
    UIView *selectionView;
    NSInteger numberOfSavedDomes;
}

@end

@implementation RearTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    //TODO this needs to be dependent on content size
    self.tableView.scrollEnabled = NO;
    
    selectionView = [[UIView alloc] init];
    [selectionView setBackgroundColor:[UIColor blueColor]];
    
//    [self loadTableSelection:[NSIndexPath indexPathForRow:0 inSection:0]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 2;
    return numberOfSavedDomes;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"New Dome";
    else
        return @"Saved Domes";
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 900, 3)];
        [v setBackgroundColor:[UIColor whiteColor]];
        return v;
    }
    return nil;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    PFObject *theBuilding = _buildings[section];
//    
//    CGRect scr = [[UIScreen mainScreen] bounds];
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,scr.size.width*.5,100)];
//
//    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(-5,100 - [[UIScreen mainScreen] bounds ].size.width*.2*.75,400,[[UIScreen mainScreen] bounds ].size.width*.2)];
//    tempLabel.backgroundColor=[UIColor clearColor];
//    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
//    tempLabel.attributedText = attrStr;
//    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:[[UIScreen mainScreen] bounds ].size.width*.2];
//    tempLabel.textAlignment = NSTextAlignmentLeft;
//    
//    [imageView addSubview:tempLabel];
//    return imageView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    

    cell.backgroundColor = [UIColor whiteColor];
//    cell.textLabel.font = [[Program wide] ul];
//    cell.textLabel.textColor = [[Program wide] colorDark];
    
    cell.selectedBackgroundView = selectionView;

    if(indexPath.row == 0)
        [cell.textLabel setText:@"Icosahedron"];
    else if(indexPath.row == 1)
        [cell.textLabel setText:@"Octahedron"];
//    NSString *title = nil;
//    if(indexPath.section == 0)
//        cell.textLabel.text = title;
//    else if(indexPath.section == 1)
//        cell.textLabel.text = title;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ViewController *viewController = [[ViewController alloc] init];
    if(indexPath.row == 0)
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] newIcosahedron];
    if(indexPath.row == 1)
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] newOctahedron];

    
//    if(indexPath.row == 0)
//        [viewController setSolidType:0];
//    if(indexPath.row == 1)
//        [viewController setSolidType:1];
    
    
//        NavigationController *navController = [[NavigationController alloc] initWithRootViewController:viewController];
//    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[NavigationBar class] toolbarClass:nil];
//    [navController setViewControllers:@[viewController]];
    
//    RearTableViewController *rearViewController = [[RearTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    SWRevealViewController *revealController = self.revealViewController;
//    SWRevealViewController *mainRevealController = [SWRevealViewController new];
//    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navController];

//    [revealController setFrontViewController:[[UINavigationController alloc] initWithRootViewController:viewController]];
    [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//    SWRevealViewController *revealController = self.revealViewController;
//
//    if(_lastSelection.row == indexPath.row && _lastSelection.section == indexPath.section){
//        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//        return;
//    }
//    else{
//        [self loadTableSelection:indexPath];
//    }
}

-(void) loadTableSelection:(NSIndexPath*)indexPath{
    _lastSelection = indexPath;
    
//    SWRevealViewController *revealController = self.revealViewController;

//    UIViewController *front = nil;
//    if(indexPath.row == 2){
//        BlogTableViewController *blogVC = [[BlogTableViewController alloc] init];
//        front = blogVC;
//    }
//    if(front){
//        [revealController setFrontViewController:front animated:YES];
//        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//    }
    
    if(indexPath.section == 0){
        NSLog(@"now overwriting front view controller correctly");
//        [revealController setFrontViewController:feed animated:YES];
//        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
    else{
        if(indexPath.row == 0){
//            ProfileNavigationController *profileNavController = [[ProfileNavigationController alloc] init];
//            [revealController setFrontViewController:profileNavController animated:YES];
//            [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        }
        else if(indexPath.row == 1){
        }
        else if(indexPath.row == 2){
        }
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
