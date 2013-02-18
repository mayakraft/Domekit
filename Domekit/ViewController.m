//
//  ViewController.m
//  Domekit
//
//  Created by Robby on 1/28/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize instructionButton;
@synthesize domeVLabel;
@synthesize cropButton;
//@synthesize sizeButton;
//@synthesize sizeLabel;
//@synthesize sizeFPartLabel;
//@synthesize sizeView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //sizeToggle = false;
    //domeSize = 10;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    domeView = [[DomeView alloc] initWithFrame:CGRectMake([self.view bounds].size.width*.05,
                                                          [self.view bounds].size.height*.1,
                                                          [self.view bounds].size.width*.9,
                                                          [self.view bounds].size.width*.9)];
    [domeView.layer setCornerRadius:15.0f];
    domeView.layer.masksToBounds = TRUE;
    domeView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    domeView.layer.borderWidth = 3;
    [domeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blackboard_320.png"]]];
    [self.view addSubview:domeView];
    [self.view sendSubviewToBack:domeView];
    
    diagramView = [[DiagramView alloc] initWithFrame:CGRectMake([self.view bounds].size.width-98, [self.view bounds].size.height-98, 86, 86) Dome:domeView.dome];
    //[domeView capturePoles];
    [diagramView importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
    [diagramView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:diagramView];
    [self.view sendSubviewToBack:diagramView];
    
    [instructionButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
    [instructionButton setBackgroundImage:[UIImage imageNamed:@"foggydark.png"] forState:UIControlEventTouchDown];
    [instructionButton.layer setCornerRadius:7.0f];
    instructionButton.layer.masksToBounds = TRUE;
    instructionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    instructionButton.layer.borderWidth = 1;
    //[instructionButton.layer setClipToBounds:YES];
    
    /*voyagerman = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagerman.png"]];
    voyagerman.frame = CGRectMake(0,0,domeView.bounds.size.height*.4,domeView.bounds.size.height);
    voyagerman.alpha = .4;
    voyagercat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagercat.png"]];
    voyagercat.frame = CGRectMake(0,0,domeView.bounds.size.height*.3,domeView.bounds.size.height*.3*.75);
    voyagercat.alpha = 0;
    scaleFigureView = [[UIView alloc] initWithFrame:domeView.frame];
    scaleFigureView.backgroundColor = [UIColor clearColor];
    scaleFigureView.hidden = TRUE;
    scaleFigureView.clipsToBounds = YES;
    [scaleFigureView addSubview:voyagerman];
    [scaleFigureView addSubview:voyagercat];
    [self.view addSubview:scaleFigureView];
    
    domeCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle.png"]];
    domeCircle.frame = CGRectMake(12, [self.view bounds].size.height-98, 86, 86);
    domeCircle.contentMode = UIViewContentModeTopLeft; // This determines position of image
    domeCircle.clipsToBounds = YES;
    [self.view addSubview:domeCircle];
    [self.view sendSubviewToBack:domeCircle];*/
    
    cropButton.adjustsImageWhenHighlighted = false;
    [cropButton setTitleColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0] forState:UIControlEventTouchDown];
    cropButton.layer.masksToBounds = TRUE;
    cropButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    cropButton.layer.borderWidth = 3;
    [cropButton setBackgroundColor:[UIColor whiteColor]];
    [cropButton addTarget:self action:@selector(toggleSpliceMode) forControlEvents:UIControlEventTouchDown];

    /*sizeButton.layer.masksToBounds = TRUE;
    sizeButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    sizeButton.layer.borderWidth = 3;
    [sizeButton setBackgroundColor:[UIColor whiteColor]];
    [sizeButton addTarget:self action:@selector(toggleSizeMode) forControlEvents:UIControlEventTouchDown];
    [sizeButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.8 alpha:1.0] forState:UIControlEventTouchDown];
    */
    //[self.view bringSubviewToFront:sizeView];
    //[self adjustSizeView];
    //[sizeView setFrame:CGRectMake(200, 100, sizeView.frame.size.width, sizeView.frame.size.height)];
    
    /*heightMarker = [[HeightMarker alloc] initWithFrame:CGRectMake(95, [self.view bounds].size.height-98, 15, 86)];
    [heightMarker setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:heightMarker];
    [self.view bringSubviewToFront:heightMarker];
*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:2];
    [tapGesture addTarget:self action:@selector(tapListener:)];
    [self.view addGestureRecognizer:tapGesture];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] init];
    [pinchGesture addTarget:self action:@selector(pinchListener:)];
    [self.view addGestureRecognizer:pinchGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    [panGesture addTarget:self action:@selector(panListener:)];
    [self.view addGestureRecognizer:panGesture];
}

- (IBAction)valueChanged:(UIStepper *)sender {
    int value = [sender value];
    if(value > 0){
        [domeView generate:value];
        [diagramView importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        
        //[self refreshHeight];
        //[self adjustSizeView];

        NSString *string = [[NSString alloc] initWithFormat:@"•"];
        for(int i = 1; i < value; i++) string = [string stringByAppendingString:@"•"];
        domeVLabel.text = string;
    }
}
/*
-(void) adjustSizeView
{
    CGFloat y = domeCircle.frame.origin.y+5;
    if(y > 390) y = 390;
    if((domeSize*[diagramView getDomeHeight]) < 10)
        [sizeView setFrame:CGRectMake(-2, y, 92, 50)];//CGRectMake(15, 475, 92, 50)];
    else if((domeSize*[diagramView getDomeHeight]) < 100)
        [sizeView setFrame:CGRectMake(9, y, 92, 50)];//CGRectMake(10, 475, 92, 50)];
    else
        [sizeView setFrame:CGRectMake(22, y, 92, 50)];//CGRectMake(5, 475, 92, 50)];

}*/

/*
-(void) refreshHeight
{
    int height = 86 * [diagramView getDomeHeight];
    domeCircle.frame = CGRectMake(22, [self.view bounds].size.height-98+(86-height), 86, height);
    sizeLabel.text = [NSString stringWithFormat:@"%d",(int)(domeSize*[diagramView getDomeHeight])];
    sizeFPartLabel.text = [NSString stringWithFormat:@"%d", (int)floorf( 10*(domeSize*[diagramView getDomeHeight]-(int)(domeSize*[diagramView getDomeHeight])) ) ];
    heightMarker.frame = CGRectMake(5, [self.view bounds].size.height-98+(86-height), 15, height);
    [heightMarker setNeedsDisplay];
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"InstructionSegue"]) {
        InstructionsViewController *instructions = (InstructionsViewController *)segue.destinationViewController;
        //instructions.StrutScale = domeSize;
        instructions.diagramView = [[DiagramView alloc] initWithFrame:[[UIScreen mainScreen]bounds] Dome:domeView.dome];
        [instructions.diagramView importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        [instructions.diagramView setScale:100];
    }
}

-(void) tapListener:(UITapGestureRecognizer*)sender
{
    //NSLog(@"%f %f",domeView.bounds.origin.x, domeView.bounds.origin.y);
    if (CGRectContainsPoint(domeView.frame, [sender locationInView:self.view]))
        [self toggleSpliceMode];
    
}

-(void) pinchListener:(UIPinchGestureRecognizer*)sender
{
    if (CGRectContainsPoint(domeView.frame, [sender locationInView:self.view]))
    {
        if([sender state] == 1) touchPinch = [domeView getScale];
        [domeView setScale:[sender scale] * touchPinch];
        [domeView refresh];
    }
}

-(void) panListener:(UIPanGestureRecognizer*)sender
{
    //CGPoint location = [sender locationInView:self.view];
    if (CGRectContainsPoint(domeView.frame, [sender locationInView:self.view]))
    {
        CGPoint translation = [sender translationInView:self.view];
        /*if (sizeToggle)
        {
            if([sender state] == 1) touchPanSize = domeSize;
            
            domeSize = translation.y/400*domeSize + touchPanSize;
            
            double sphereHeight = [domeView getScale] * 2 * sqrt( ((1 + sqrt(5)) / 2 ) + 2 );
            int margin = (scaleFigureView.bounds.size.height - sphereHeight)/2;  // between tip of dome and border
            int floor = margin+ sphereHeight*[diagramView getDomeHeight];
            if(domeSize < 4){
                voyagerman.alpha = 0;
                voyagercat.alpha = .4;
            }
            else if(domeSize > 6) {
                voyagerman.alpha = .4;
                voyagercat.alpha = .0;
            }
            else {
                voyagerman.alpha = .4*((domeSize-4)/2);
                voyagercat.alpha = .4*(1-(domeSize-4)/2);
            }
            
            voyagerman.frame = CGRectMake(scaleFigureView.bounds.size.width/2.0 - (1/(domeSize/6)*scaleFigureView.bounds.size.height*.8*.4)/2,
                                          floor-1/(domeSize/6)*scaleFigureView.bounds.size.height*.8,
                                          1/(domeSize/6)*scaleFigureView.bounds.size.height*.8*.4,
                                          1/(domeSize/6)*scaleFigureView.bounds.size.height*.8);
            //CGRectMake(0,0,domeView.bounds.size.height*.3,domeView.bounds.size.height*.3*.75)
            voyagercat.frame = CGRectMake(scaleFigureView.bounds.size.width/2.0 - (1/(domeSize/6)*scaleFigureView.bounds.size.height*.3)/2,
                                          floor-1/(domeSize/6)*scaleFigureView.bounds.size.height*.3*.75,
                                          1/(domeSize/6)*scaleFigureView.bounds.size.height*.3,
                                          1/(domeSize/6)*scaleFigureView.bounds.size.height*.3*.75);
            sizeLabel.text = [NSString stringWithFormat:@"%d",(int)(domeSize*[diagramView getDomeHeight])];
            sizeFPartLabel.text = [NSString stringWithFormat:@"%d", (int)floorf( 10*(domeSize*[diagramView getDomeHeight]-(int)(domeSize*[diagramView getDomeHeight])) ) ];
            //[self adjustSizeView];
        }*/
        if([domeView getSpliceMode])
        {
            if([sender state] == 1) touchPanEdit = [domeView getSpliceY];
            double spliceLocation = touchPanEdit+translation.y/[domeView getScale];
            if(spliceLocation < -2) [domeView setSpliceY:-2];
            else if (spliceLocation > 2) [domeView setSpliceY:2];
            else [domeView setSpliceY:spliceLocation];
        }
        else
        {
            if([sender state] == 1) touchPanRotate = [domeView getRotation];
            else if( [sender state] == 3) [domeView setRotationX:[touchPanRotate getX]-translation.y/200.0
                                                               Y:[touchPanRotate getY]-translation.x/200.0
                                                               Z:[touchPanRotate getZ]];
            [domeView setRotationX:[touchPanRotate getX]-translation.y/200.0 Y:[touchPanRotate getY]-translation.x/200.0 Z:0];
        }
        [domeView refresh];
    }
}

-(void) toggleSpliceMode
{
    //if(sizeToggle) [self toggleSizeMode];
    if([domeView getSpliceMode]){
        [cropButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cropButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        domeView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        [domeView capturePoles];
        [domeView setSpliceMode:false];
        [diagramView importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        [cropButton setTitleColor:[UIColor lightGrayColor] forState:UIControlEventTouchDown];
        //[self refreshHeight];
        //[self adjustSizeView];
    }
    else{
        domeView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
        cropButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
        [cropButton setTitleColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [domeView setSpliceMode:true];
        [cropButton setTitleColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0] forState:UIControlEventTouchDown];
    }
    [domeView refresh];    
}
/*
-(void) toggleSizeMode
{
    if([domeView getSpliceMode]) [self toggleSpliceMode];
    if(sizeToggle){
        [sizeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        sizeButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        domeView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        sizeToggle = false;
        [sizeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlEventTouchDown];
        scaleFigureView.hidden = TRUE;
    }
    else{
        domeView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.8 alpha:1.0].CGColor;
        sizeButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.8 alpha:1.0].CGColor;
        [sizeButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.8 alpha:1.0] forState:UIControlStateNormal];
        sizeToggle = true;
        [sizeButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.8 alpha:1.0] forState:UIControlEventTouchDown];
        scaleFigureView.hidden = FALSE;
        int floor;
        double sphereHeight = [domeView getScale] * 2 * sqrt( ((1 + sqrt(5)) / 2 ) + 2 );
        int margin = (scaleFigureView.bounds.size.height - sphereHeight)/2;  // between tip of dome and border
        floor = margin+ sphereHeight*[diagramView getDomeHeight];
        voyagerman.frame = CGRectMake(scaleFigureView.bounds.size.width/2.0 - (1/(domeSize/6)*scaleFigureView.bounds.size.height*.8*.4)/2,
                                      floor-1/(domeSize/6)*scaleFigureView.bounds.size.height*.8,
                                      1/(domeSize/6)*scaleFigureView.bounds.size.height*.8*.4,
                                      1/(domeSize/6)*scaleFigureView.bounds.size.height*.8);
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
