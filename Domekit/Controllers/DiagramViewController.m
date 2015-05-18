//
//  DiagramViewController.m
//  Domekit
//
//  Created by Robby on 5/10/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "DiagramViewController.h"

#import "EquidistantAzimuthView.h"


@interface DiagramViewController () <UIActionSheetDelegate>
{
    int polaris, octantis;
    NSArray *colorTable;
}

@end

@implementation DiagramViewController

-(id) init{
    self = [super init];
    if(self){
        _scale = defaultScale;
        _lineWidth = defaultLineWidth;
    }
    return self;
}

-(void) setGeodesicModel:(GeodesicModel *)geodesicModel{
    _geodesicModel = geodesicModel;
    [self getLengthOrder];
}


-(NSArray*) getLengthOrder
{
    NSMutableArray *lengthOrder = [[NSMutableArray alloc] initWithCapacity:_geodesicModel.lineClassLengths.count];
    int i, j, index;
    for(i = 0; i < _geodesicModel.lineClassLengths.count; i++) [lengthOrder addObject:[[NSNumber alloc] initWithInt:0]];
    for(i = 0; i < _geodesicModel.lineClassLengths.count; i++){
        index = 0;
        for(j = 0; j < _geodesicModel.lineClassLengths.count; j++){
            if(i!=j && [_geodesicModel.lineClassLengths[i] doubleValue] > [_geodesicModel.lineClassLengths[j] doubleValue]) index++;
        }
        lengthOrder[index] = [[NSNumber alloc] initWithInt:i];
    }
    return [[NSArray alloc] initWithArray:lengthOrder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    colorTable = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0],  //red
                  [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0],  //blue
                  [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0],  //green
                  [UIColor colorWithRed:0.53 green:0 blue:0.8 alpha:1.0],  //purple
                  [UIColor colorWithRed:1 green:0.66 blue:0 alpha:1.0],   //orange
                  [UIColor colorWithRed:0 green:0.66 blue:0.66 alpha:1.0], //teal
                  [UIColor colorWithRed:0.88 green:0.88 blue:0 alpha:1.0],  //gold
                  [UIColor colorWithRed:0.86 green:0 blue:0.73 alpha:1.0],  //pink
                  [UIColor colorWithRed:0.66 green:.88 blue:0 alpha:1.0],  // lime green
                  [UIColor colorWithRed:0.62 green:.42 blue:0.27 alpha:1.0],  // brown
                  [UIColor colorWithRed:0.6 green:0.725 blue:0.95 alpha:1.0],  // light blue
                  [UIColor colorWithRed:1 green:0.81 blue:0.51 alpha:1.0],  // salmon
                  [UIColor colorWithRed:.89 green:0.6 blue:0.97 alpha:1.0],  // light purple
                  [UIColor colorWithRed:.5 green:1 blue:1 alpha:1.0],  // cyan
                  [UIColor colorWithRed:.75 green:.75 blue:.15 alpha:1.0],  // dull yellow
                  [UIColor colorWithRed:0 green:.63 blue:.42 alpha:1.0],  // sea green
                  [UIColor colorWithRed:0.26 green:0.19 blue:0.73 alpha:1.0],  // purple-blue
                  [UIColor colorWithRed:0.2 green:0.47 blue:0.16 alpha:1.0],  // forest green
                  [UIColor colorWithRed:0.19 green:0.37 blue:0.52 alpha:1.0],  // gray blue
                  [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0], nil];  //gray
    

    // Do any additional setup after loading the view.
    [self setTitle:@"3V 5/9 DIAGRAM"];
    
//    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
//    EquidistantAzimuthView *azimuthView = [[EquidistantAzimuthView alloc] initWithFrame:CGRectMake(0, (windowSize.height-windowSize.width)*.5, windowSize.width, windowSize.width)];
//    [self.view addSubview:azimuthView];
    
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    
    EquidistantAzimuthView *view = [[EquidistantAzimuthView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
    [self setView:view];
    
//    UIBarButtonItem *makeButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:nil action:NULL];
//    self.navigationItem.rightBarButtonItem = makeButton;

    UIBarButtonItem *makeButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = makeButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) backButtonPressed{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.55];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelay:0.375];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
//    [UIView commitAnimations];
}

-(void) saveButtonPressed{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Nope" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Save Image to Photos", nil];
    [actionSheet showInView:self.view];
}

-(void) shareButtonPressed{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"PDF Instructions" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Save to Photos", nil];
    [actionSheet showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
