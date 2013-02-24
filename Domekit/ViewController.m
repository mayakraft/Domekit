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
@synthesize modelButton;
@synthesize sizeButton;
@synthesize instructionButton;
@synthesize pageNumber;
@synthesize cropButton;
@synthesize VLabel;
@synthesize FractionLabel;
@synthesize SolidLabel;
@synthesize solidView;
@synthesize stepper;
@synthesize icosaButton;
@synthesize octaButton;
@synthesize modelWindow;
//@synthesize sizeButton;
//@synthesize sizeLabel;
//@synthesize sizeFPartLabel;
//@synthesize sizeView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //sizeToggle = false;
    //domeSize = 10;
    VNumber = 1;
    icosahedron = true;
    alignToSplice = true;

    icosaButton.enabled = false;

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid_17dark.png"]]];

    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                [self.view bounds].size.width,
                                                                23)];
    [titleBar setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:titleBar];
    [self.view sendSubviewToBack:titleBar];

    UIView *gridView = [[UIView alloc] initWithFrame:CGRectMake(-1,
                                                              105,
                                                              [self.view bounds].size.width+2,
                                                              [self.view bounds].size.height+2-105)];
    [gridView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    gridView.layer.borderColor = [UIColor grayColor].CGColor;
    gridView.layer.borderWidth = 1;
    [self.view addSubview:gridView];
    [self.view sendSubviewToBack:gridView];
    
////////////
// MODEL WINDOW
////////////
    
    domeView = [[DomeView alloc] initWithFrame:CGRectMake([self.view bounds].size.width*.05,
                                                          15/*[self.view bounds].size.height*.1*/,
                                                          [self.view bounds].size.width*.9,
                                                          [self.view bounds].size.width*.9)];
    [domeView.layer setCornerRadius:15.0f];
    domeView.layer.masksToBounds = TRUE;
    domeView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    domeView.layer.borderWidth = 3;
    [domeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blackboard_320.png"]]];
    [modelWindow addSubview:domeView];
    [modelWindow sendSubviewToBack:domeView];
    
    cropButton.adjustsImageWhenHighlighted = false;
    [cropButton setTitleColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0] forState:UIControlEventTouchDown];
    [cropButton.layer setCornerRadius:7.0f];
    [cropButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cropButton.layer.masksToBounds = TRUE;
    cropButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cropButton.layer.borderWidth = 1;
    [cropButton setBackgroundColor:[UIColor whiteColor]];
    [cropButton addTarget:self action:@selector(toggleSpliceMode) forControlEvents:UIControlEventTouchDown];


///////////
// SIZE WINDOW
///////////
    
    sizeWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 105, 320, 355)];
    sizeWindow.hidden = true;
    [self.view addSubview:sizeWindow];
    
    voyagerman = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagermandark.png"]];
    voyagercat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagercatdark.png"]];
    domeCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle"]];
    
    [voyagerman setFrame:CGRectMake(190, 20, 48, 120)];
    [domeCircle setFrame:CGRectMake(30, 20, 150, 150)];
    [sizeWindow addSubview:voyagerman];
    [sizeWindow addSubview:domeCircle];
    
///////////
// INSTRUCTION
///////////
    
    instructionWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 105, 320, 355)];
    instructionWindow.hidden = true;
    [self.view addSubview:instructionWindow];
    
    diagramView = [[DiagramView alloc] initWithFrame:CGRectMake(0,-15,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width) Dome:domeView.dome];
    //[diagramView setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width)];
    [diagramView setBackgroundColor:[UIColor clearColor]];
    [instructionWindow addSubview:diagramView];
    [instructionWindow sendSubviewToBack:diagramView];
    [diagramView setScale:130];
    [diagramView setLineWidth:4.0];
    //[diagramView setNeedsDisplay];
    
    UILabel *nodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, instructionWindow.bounds.size.height-70, 200, 30)];
    [nodeLabel setBackgroundColor:[UIColor clearColor]];
    [nodeLabel setTextColor:[UIColor blackColor]];
    [nodeLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    nodeLabel.text = [NSString stringWithFormat:@"NODES"];
    [instructionWindow addSubview:nodeLabel];
    
    UILabel *strutLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, instructionWindow.bounds.size.height-40, 200, 30)];
    [strutLabel setBackgroundColor:[UIColor clearColor]];
    [strutLabel setTextColor:[UIColor blackColor]];
    [strutLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    strutLabel.text = [NSString stringWithFormat:@"STRUTS"];
    [instructionWindow addSubview:strutLabel];
    
    //UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.bounds.size.height-40, 200, 30)];
    //[faceLabel setBackgroundColor:[UIColor clearColor]];
    //[faceLabel setTextColor:[UIColor blackColor]];
    //[faceLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    //faceLabel.text = [NSString stringWithFormat:@"FACES"];
    //[self.view addSubview:faceLabel];
    
    nodeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(instructionWindow.bounds.size.width-90, instructionWindow.bounds.size.height-70, 75, 30)];
    [nodeCountLabel setBackgroundColor:[UIColor clearColor]];
    [nodeCountLabel setTextColor:[UIColor blackColor]];
    [nodeCountLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    [nodeCountLabel setTextAlignment:NSTextAlignmentRight];
    nodeCountLabel.text = [NSString stringWithFormat:@"%d",[diagramView getPointCount]];
    [instructionWindow addSubview:nodeCountLabel];
    
    strutCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(instructionWindow.bounds.size.width-90, instructionWindow.bounds.size.height-40, 75, 30)];
    [strutCountLabel setBackgroundColor:[UIColor clearColor]];
    [strutCountLabel setTextColor:[UIColor blackColor]];
    [strutCountLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    [strutCountLabel setTextAlignment:NSTextAlignmentRight];
    strutCountLabel.text = [NSString stringWithFormat:@"%d",[diagramView getLineCount]];
    [instructionWindow addSubview:strutCountLabel];
    
    UIButton *nodeButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [nodeButton setFrame:CGRectMake(7, instructionWindow.bounds.size.height-70, 30, 30)];
    [instructionWindow addSubview:nodeButton];
    
    UIButton *strutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [strutButton setFrame:CGRectMake(7, instructionWindow.bounds.size.height-40, 30, 30)];
    [instructionWindow addSubview:strutButton];
    //[strutButton addTarget:self action:@selector(strutDetailPress:) forControlEvents:UIControlEventTouchUpInside];

    
    //[modelButton setFrame:CGRectMake(21, 29, 80, 80)];
    //[modelButton setBounds:CGRectMake(0, 0, 80, 80)];
    //modelButton.layer.anchorPoint = CGPointMake(0, 0);

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
    
////////////
// TAB BAR BUTTONS
////////////
        
    [modelButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
    [modelButton setBackgroundImage:[UIImage imageNamed:@"foggydark.png"] forState:UIControlEventTouchDown];
    [modelButton.layer setCornerRadius:7.0f];
    modelButton.layer.masksToBounds = TRUE;
    modelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    modelButton.layer.borderWidth = 1;
    [modelButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    [modelButton setBounds:CGRectMake(0, 0, 96, 90)];
    [modelButton setFrame:CGRectMake(8, 29, 96, 90)];
    coverup = [[UIView alloc] initWithFrame:CGRectMake(9, 105, 94, 1)];
    [coverup setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    [self.view addSubview:coverup];
    
    [sizeButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    [sizeButton.layer setCornerRadius:7.0f];
    sizeButton.layer.masksToBounds = TRUE;
    sizeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sizeButton.layer.borderWidth = 1;
    UIImageView *domePreview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle.png"]];
    [domePreview setFrame:CGRectMake(5, 8, 54, 54)];
    UIImageView *voyagermanPreview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagermandark.png"]];
    [voyagermanPreview setFrame:CGRectMake(62, 5, 24, 60)];
    [voyagermanPreview setAlpha:0.3];
    [sizeButton addSubview:voyagermanPreview];
    [sizeButton addSubview:domePreview];
    
    [instructionButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
    [instructionButton setBackgroundImage:[UIImage imageNamed:@"foggydark.png"] forState:UIControlEventTouchDown];
    [instructionButton.layer setCornerRadius:7.0f];
    instructionButton.layer.masksToBounds = TRUE;
    instructionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    instructionButton.layer.borderWidth = 1;
    //[instructionButton.layer setClipToBounds:YES];
    diagramPreview = [[DiagramView alloc] initWithFrame:CGRectMake(216, 29, 96, 70) Dome:domeView.dome];
    //[domeView capturePoles];
    [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
    [diagramPreview setBackgroundColor:[UIColor whiteColor]];
    [diagramPreview.layer setCornerRadius:7.0f];
    diagramPreview.layer.masksToBounds = TRUE;
    [self.view addSubview:diagramPreview];
    
    [self.view sendSubviewToBack:modelButton];
    [self.view sendSubviewToBack:sizeButton];
    [self.view sendSubviewToBack:instructionButton];
    [self.view sendSubviewToBack:diagramPreview];
   
    
////////////
// GESTURES
////////////

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

-(IBAction)modelButtonPress:(id)sender
{
    //CGRect rect = modelButton.bounds;
    [modelButton setBounds:CGRectMake(0, 0, 96, 90)];
    [modelButton setFrame:CGRectMake(8, 29, 96, 90)];
    [sizeButton setBounds:CGRectMake(0, 0, 96, 71)];
    [sizeButton setFrame:CGRectMake(112, 29, 96, 71)];
    [instructionButton setBounds:CGRectMake(0, 0, 96, 71)];
    [instructionButton setFrame:CGRectMake(216, 29, 96, 71)];
    [coverup setFrame:CGRectMake(9, 105, 94, 1)];
    modelWindow.hidden = false;
    sizeWindow.hidden = true;
    instructionWindow.hidden = true;
    pageNumber.text = [NSString stringWithFormat:@"MODEL"];

}

-(IBAction)sizeButtonPress:(id)sender
{
    //CGRect rect = modelButton.bounds;
    [modelButton setBounds:CGRectMake(0, 0, 96, 71)];
    [modelButton setFrame:CGRectMake(8, 29, 96, 71)];
    [sizeButton setBounds:CGRectMake(0, 0, 96, 90)];
    [sizeButton setFrame:CGRectMake(112, 29, 96, 90)];
    [instructionButton setBounds:CGRectMake(0, 0, 96, 71)];
    [instructionButton setFrame:CGRectMake(216, 29, 96, 71)];
    [coverup setFrame:CGRectMake(113, 105, 94, 1)];
    modelWindow.hidden = true;
    sizeWindow.hidden = false;
    instructionWindow.hidden = true;
    pageNumber.text = [NSString stringWithFormat:@"SIZE"];

}

-(IBAction)instructionButtonPress:(id)sender
{
    //CGRect rect = modelButton.bounds;
    [modelButton setBounds:CGRectMake(0, 0, 96, 71)];
    [modelButton setFrame:CGRectMake(8, 29, 96, 71)];
    [sizeButton setBounds:CGRectMake(0, 0, 96, 71)];
    [sizeButton setFrame:CGRectMake(112, 29, 96, 71)];
    [instructionButton setBounds:CGRectMake(0, 0, 96, 90)];
    [instructionButton setFrame:CGRectMake(216, 29, 96, 90)];
    [coverup setFrame:CGRectMake(217, 105, 94, 1)];
    modelWindow.hidden = true;
    sizeWindow.hidden = true;
    instructionWindow.hidden = false;
    pageNumber.text = [NSString stringWithFormat:@"ASSEMBLY DIAGRAM"];
    
    //diagramView = [[DiagramView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width) Dome:domeView.dome];
    //[diagramView setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width)];
    [diagramView importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
    [diagramView setScale:130];
    [diagramView setLineWidth:4.0];
    [diagramView setNeedsDisplay];

    nodeCountLabel.text = [NSString stringWithFormat:@"%d",[diagramView getPointCount]];
    strutCountLabel.text = [NSString stringWithFormat:@"%d",[diagramView getLineCount]];
    /*NSArray *speciesCount = [[NSArray alloc] initWithArray:[diagramView getVisibleLineSpeciesCount]];
    NSMutableArray *lineLabels = [[NSMutableArray alloc] init];
    NSMutableArray *lengthLabels = [[NSMutableArray alloc] init];
    NSMutableArray *lengthOrder = [[NSMutableArray alloc] initWithArray:[diagramView getLengthOrder]];
    int i, j, index;
    for(i = 0; i < diagramView.dome.lineClassLengths_.count; i++) [lengthOrder addObject:[[NSNumber alloc] initWithInt:0]];
    for(i = 0; i < diagramView.dome.lineClassLengths_.count; i++){
        index = 0;
        for(j = 0; j < diagramView.dome.lineClassLengths_.count; j++){
            if(i!=j && [diagramView.dome.lineClassLengths_[i] doubleValue] > [diagramView.dome.lineClassLengths_[j] doubleValue]) index++;
        }
        lengthOrder[index] = [[NSNumber alloc] initWithInt:i];
    }*/

}

- (IBAction)valueChanged:(UIStepper *)sender {
    VNumber = [sender value];
    if(VNumber > 0){
        
        if(alignToSplice) [domeView align];
        [domeView generate:VNumber];
        [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        
        //[self refreshHeight];
        //[self adjustSizeView];
        if([domeView isSphere]) FractionLabel.text = [NSString stringWithFormat:@"SPHERE"];
        else FractionLabel.text = [NSString stringWithFormat:@"DOME"];

        VLabel.text = [NSString stringWithFormat:@"%dV",VNumber];
    }
}

-(IBAction)alignDomeButton:(id)sender
{
    if(alignToSplice){
        alignToSplice = false;
        [sender setAlpha:.17];
    }
    else{
        alignToSplice = true;
        [sender setAlpha:.6];
    }
}

-(IBAction)solidChange:(id)sender
{
    if(alignToSplice) [domeView align];
    if(icosahedron)
    {
        solidView.image = [UIImage imageNamed:@"octahedron_icon.png"];
        SolidLabel.text = [NSString stringWithFormat:@"OCTAHEDRON"];
        icosaButton.enabled = true;
        octaButton.enabled = false;
        icosahedron = false;
        stepper.maximumValue = 4;
        if(VNumber > 4) {VNumber = 4; stepper.value = 4;VLabel.text = [NSString stringWithFormat:@"%dV",VNumber];}
        [domeView.dome setOctahedron];
        [diagramPreview.dome setOctahedron];
        [domeView generate:VNumber];
        [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
    }
    else{
        solidView.image = [UIImage imageNamed:@"icosahedron_icon.png"];
        SolidLabel.text = [NSString stringWithFormat:@"ICOSAHEDRON"];
        icosaButton.enabled = false;
        octaButton.enabled = true;
        icosahedron = true;
        stepper.maximumValue = 64;
        [domeView.dome setIcosahedron];
        [diagramPreview.dome setIcosahedron];
        [domeView generate:VNumber];
        [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
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

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"InstructionSegue"]) {
        InstructionsViewController *instructions = (InstructionsViewController *)segue.destinationViewController;
        //instructions.StrutScale = domeSize;
        instructions.diagramView = [[DiagramView alloc] initWithFrame:[[UIScreen mainScreen]bounds] Dome:domeView.dome];
        [instructions.diagramView importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        [instructions.diagramView setScale:100];
    }
}*/

-(void) tapListener:(UITapGestureRecognizer*)sender
{
    //NSLog(@"%f %f",domeView.bounds.origin.x, domeView.bounds.origin.y);
    //if (CGRectContainsPoint(domeView.frame, [sender locationInView:self.view]))
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
    //if (CGRectContainsPoint(domeView.frame, [sender locationInView:self.view]))
    //{
        CGPoint translation = [sender translationInView:self.view];
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
    //}
}

-(void) toggleSpliceMode
{
    if([domeView getSpliceMode]){
        [cropButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cropButton.layer setCornerRadius:7.0f];
        cropButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cropButton.layer.borderWidth = 1.0;
        domeView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        [domeView capturePoles];
        [domeView setSpliceMode:false];
        [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        [cropButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        if([domeView isSphere]) FractionLabel.text = [NSString stringWithFormat:@"SPHERE"];
        else FractionLabel.text = [NSString stringWithFormat:@"DOME"];
    }
    else{
        domeView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
        cropButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
        cropButton.layer.borderWidth = 3.0;
        [cropButton setTitleColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        if(alignToSplice) [domeView align];
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
