//
//  ViewController.m
//  Domekit
//
//  Created by Robby on 1/28/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "DomeView.h"
#import "DiagramView.h"
#import "Point3D.h"
#import "HeightMarker.h"

@interface ViewController ()
{
    //TAB BAR BUTTONS
    UIView *coverup;
    DiagramView *diagramPreview;
    UIImageView *domePreview;
    HeightMarker *heightMarkerPreview;
    
    //MODEL VIEW
    DomeView *domeView;
    Point3D *touchPanRotate;  // last position in pan during rotate mode
    CGFloat touchPanEdit;     // last position in pan during slice mode
    CGFloat touchPinch;       // last position in pinch to scale
    CGPoint touchOrigin;     // origin of panning, to check if it began on the drawing square
    BOOL icosahedron;       // TRUE=icosahedron, FALSE=octahedron
    BOOL alignToSlice;        // auto-aligns dome before splicing
    int VNumber;             //dome Frequency
    
    //SIZE VIEW
    UIView *sizeWindow;
    UIView *scaleFigureView;
    UIImageView *voyagerman;
    UIImageView *voyagercat;
    UIImageView *domeCircle;
    CGFloat domeCircleScale;
    CGFloat domeSizeGround;   // screen location on which to stand man and cat
    UILabel *heightValueLabel;
    UILabel *longestStrutLengthLabel;
    CGFloat touchPanSize;     // last position in pan during size mode
    CGFloat domeSize;          // height of dome in feet
    CGFloat domeHeightRatio;
    CGFloat longestStrut;       // length of longest strut in feet
    CGFloat longestStrutRatio; // longest strut, a ratio 0 to 1, 1 being total height of dome sphere
    BOOL sizeLockMode;        // lock size to domeHeight (0) or longestStrut (1) when switching between domes
    UIButton *lockHeight;
    UIButton *lockStrut;
    
    //INSTRUCTION VIEW
    UIView *instructionWindow;
    DiagramView *diagramView;
    UIView *nodeData;
    UIView *faceData;
    UILabel *nodeCountLabel;
    UILabel *strutCountLabel;
    UIScrollView *strutNodeScrollView;
}
@end

@implementation ViewController
@synthesize modelButton;
@synthesize sizeButton;
@synthesize instructionButton;
@synthesize aboveInstructionButton;
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
@synthesize polyButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    domeSize = 10;   // 10 feet tall
    domeCircleScale = 260;
    sizeLockMode = FALSE;  // lock to domeHeight
    VNumber = 1; 
    icosahedron = true;  //initial polyhedron: icosahedron
    icosaButton.enabled = false;  
    alignToSlice = true;
    // general page layout
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid_17dark.png"]]];
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,23)];
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
                                                          (self.view.bounds.size.height-self.view.bounds.size.width-135)/2,
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
    [cropButton addTarget:self action:@selector(toggleSliceMode) forControlEvents:UIControlEventTouchDown];
    
    //cropButton
    //stepper
    //polyButton   //these elements could be sized better
    //octaButton
    //icosaButton

///////////
// SIZE WINDOW
///////////
    
    sizeWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 105, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-105-20)];
    sizeWindow.hidden = true;
    [self.view addSubview:sizeWindow];
    
    voyagerman = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagerman.png"]];
    voyagercat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagercat.png"]];
    domeCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle_260.png"]];
    domeCircle.contentMode = UIViewContentModeTopLeft; // This determines position of image
    //domeCircle.contentMode = UIViewContentModeScaleAspectFill;
    domeCircle.clipsToBounds = YES;
    
    [domeCircle setFrame:CGRectMake(sizeWindow.bounds.size.width/2-(domeCircleScale/2), 50, domeCircleScale, domeCircleScale)];
    [voyagerman setFrame:CGRectMake(sizeWindow.bounds.size.width/2-36, 50, 72, 180)];
    [voyagercat setAlpha:0.0];
    [sizeWindow addSubview:domeCircle];
    [sizeWindow addSubview:voyagerman];
    [sizeWindow addSubview:voyagercat];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, sizeWindow.bounds.size.height-70, 200, 30)];
    [heightLabel setBackgroundColor:[UIColor clearColor]];
    [heightLabel setTextColor:[UIColor blackColor]];
    [heightLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    heightLabel.text = [NSString stringWithFormat:@"DOME HEIGHT"];
    [sizeWindow addSubview:heightLabel];

    UILabel *longestStrutLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, sizeWindow.bounds.size.height-40, 200, 30)];
    [longestStrutLabel setBackgroundColor:[UIColor clearColor]];
    [longestStrutLabel setTextColor:[UIColor blackColor]];
    [longestStrutLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    longestStrutLabel.text = [NSString stringWithFormat:@"LONGEST STRUT"];
    [sizeWindow addSubview:longestStrutLabel];

    heightValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(sizeWindow.bounds.size.width-140, sizeWindow.bounds.size.height-70, 125, 30)];
    [heightValueLabel setBackgroundColor:[UIColor clearColor]];
    [heightValueLabel setTextColor:[UIColor blackColor]];
    [heightValueLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    [heightValueLabel setTextAlignment:NSTextAlignmentRight];
    heightValueLabel.text = [NSString stringWithFormat:@"%.2f ft",domeSize];
    [sizeWindow addSubview:heightValueLabel];
    
    longestStrutRatio = [domeView getLongestStrutLength];
    longestStrut = domeSize / [domeView getDomeHeight] * longestStrutRatio;

    longestStrutLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(sizeWindow.bounds.size.width-140, sizeWindow.bounds.size.height-40, 125, 30)];
    [longestStrutLengthLabel setBackgroundColor:[UIColor clearColor]];
    [longestStrutLengthLabel setTextColor:[UIColor blackColor]];
    [longestStrutLengthLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    [longestStrutLengthLabel setTextAlignment:NSTextAlignmentRight];
    longestStrutLengthLabel.text = [NSString stringWithFormat:@"%.2f ft",longestStrut];
    [sizeWindow addSubview:longestStrutLengthLabel];
    
    lockHeight = [[UIButton alloc] initWithFrame:CGRectMake(5, sizeWindow.bounds.size.height-70, 35, 30)];
    [lockHeight setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    [lockHeight addTarget:self action:@selector(toggleDomeHeightLockOn:) forControlEvents:UIControlEventTouchUpInside];
    [sizeWindow addSubview:lockHeight];
    lockStrut = [[UIButton alloc] initWithFrame:CGRectMake(5, sizeWindow.bounds.size.height-40, 35, 30)];
    [lockStrut setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    [lockStrut setAlpha:0.17];
    [lockStrut addTarget:self action:@selector(toggleStrutLengthLockOn:) forControlEvents:UIControlEventTouchUpInside];
    [sizeWindow addSubview:lockStrut];
    
    
///////////
// INSTRUCTION
///////////
    
    instructionWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 105, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-105-20)];
    instructionWindow.hidden = true;
    [self.view addSubview:instructionWindow];
    
    diagramView = [[DiagramView alloc] initWithFrame:CGRectMake(0,instructionWindow.bounds.size.height/2-instructionWindow.bounds.size.width/2-35,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width) Dome:domeView.dome];
    [diagramView setBackgroundColor:[UIColor clearColor]];
    [instructionWindow addSubview:diagramView];
    [instructionWindow sendSubviewToBack:diagramView];
    [diagramView setScale:130];
    [diagramView setLineWidth:4.0];
    
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
    nodeCountLabel.text = [NSString stringWithFormat:@"%d",[domeView getPointCount]];
    [instructionWindow addSubview:nodeCountLabel];
    
    strutCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(instructionWindow.bounds.size.width-90, instructionWindow.bounds.size.height-40, 75, 30)];
    [strutCountLabel setBackgroundColor:[UIColor clearColor]];
    [strutCountLabel setTextColor:[UIColor blackColor]];
    [strutCountLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    [strutCountLabel setTextAlignment:NSTextAlignmentRight];
    strutCountLabel.text = [NSString stringWithFormat:@"%d",[domeView getLineCount]];
    [instructionWindow addSubview:strutCountLabel];
    
    //UIButton *nodeButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[nodeButton setFrame:CGRectMake(7, instructionWindow.bounds.size.height-70, 30, 30)];
    //[instructionWindow addSubview:nodeButton];
    //[nodeButton addTarget:self action:@selector(nodeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *strutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [strutButton setFrame:CGRectMake(7, instructionWindow.bounds.size.height-40, 30, 30)];
    [instructionWindow addSubview:strutButton];
    [strutButton addTarget:self action:@selector(strutButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    strutNodeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, self.view.frame.size.height/5*2)];
    [strutNodeScrollView setHidden:TRUE];
    
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
    //[modelButton setBounds:CGRectMake(0, 0, 96, 90)];
    //[modelButton setFrame:CGRectMake(8, 29, 96, 90)];
    coverup = [[UIView alloc] initWithFrame:CGRectMake(9, 105, 94, 1)];
    [coverup setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    [self.view addSubview:coverup];
    
    [sizeButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
    [sizeButton setBackgroundImage:[UIImage imageNamed:@"foggydark.png"] forState:UIControlEventTouchDown];
    [sizeButton.layer setCornerRadius:7.0f];
    sizeButton.layer.masksToBounds = TRUE;
    sizeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sizeButton.layer.borderWidth = 1;
    [sizeButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    domePreview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle_54.png"]];
    [domePreview setFrame:CGRectMake(25, 8, 54, 54)];
    domePreview.contentMode = UIViewContentModeTopLeft; // This determines position of image
    domePreview.clipsToBounds = YES;
    heightMarkerPreview = [[HeightMarker alloc] initWithFrame:CGRectMake(10, 8, 10, 54)];
    [heightMarkerPreview setBackgroundColor:[UIColor clearColor]];
    [domePreview setAlpha:0.5];
    [heightMarkerPreview setAlpha:0.5];
    [sizeButton addSubview:domePreview];
    [sizeButton addSubview:heightMarkerPreview];
    
    [aboveInstructionButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
    [aboveInstructionButton setBackgroundImage:[UIImage imageNamed:@"foggydark.png"] forState:UIControlEventTouchDown];
    [aboveInstructionButton.layer setCornerRadius:7.0f];
    aboveInstructionButton.layer.masksToBounds = TRUE;
    [instructionButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
    [instructionButton setBackgroundImage:[UIImage imageNamed:@"foggydark.png"] forState:UIControlEventTouchDown];
    [instructionButton.layer setCornerRadius:7.0f];
    instructionButton.layer.masksToBounds = TRUE;
    instructionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    instructionButton.layer.borderWidth = 1;
    [instructionButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    diagramPreview = [[DiagramView alloc] initWithFrame:CGRectMake(216, 29, 96, 70) Dome:domeView.dome];
    [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
    [diagramPreview setBackgroundColor:[UIColor clearColor]];
    [diagramPreview.layer setCornerRadius:7.0f];
    diagramPreview.layer.masksToBounds = TRUE;
    [self.view addSubview:diagramPreview];
    
    [self.view sendSubviewToBack:diagramPreview];
    [self.view sendSubviewToBack:modelButton];
    [self.view sendSubviewToBack:sizeButton];
    [self.view sendSubviewToBack:instructionButton];

////////////
// GESTURES
////////////

    UITapGestureRecognizer *tapTwiceGesture = [[UITapGestureRecognizer alloc] init];
    [tapTwiceGesture setNumberOfTapsRequired:2];
    [tapTwiceGesture addTarget:self action:@selector(tapTwiceListener:)];
    [self.view addGestureRecognizer:tapTwiceGesture];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:1];
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
    [sizeButton setBounds:CGRectMake(0, 0, 96, 70)];
    [sizeButton setFrame:CGRectMake(112, 29, 96, 70)];
    [instructionButton setBounds:CGRectMake(0, 0, 96, 70)];
    [instructionButton setFrame:CGRectMake(216, 29, 96, 70)];
    [coverup setFrame:CGRectMake(9, 105, 94, 1)];
    modelWindow.hidden = false;
    sizeWindow.hidden = true;
    instructionWindow.hidden = true;
    pageNumber.text = [NSString stringWithFormat:@"MODEL"];
    [strutNodeScrollView setHidden:TRUE];   // Close when leaving Instruction Window
}

-(IBAction)sizeButtonPress:(id)sender
{
    int topMargin = (sizeWindow.bounds.size.height-sizeWindow.bounds.size.width)/2;
    longestStrutRatio = [domeView getLongestStrutLength];
    domeHeightRatio = [domeView getDomeHeight];
 
    if(domeHeightRatio == 0)  /* in case the user just built a dome with no points */
    {
        heightValueLabel.text = [NSString stringWithFormat:@"0 ft"];
        longestStrutLengthLabel.text = [NSString stringWithFormat:@"0 ft"];
    }
    else
    {
        if(!sizeLockMode) /* lock to dome height */
            longestStrut = domeSize / domeHeightRatio * longestStrutRatio;
        else  /*lock to longest strut length */
            domeSize = domeHeightRatio * longestStrut / longestStrutRatio;
    
        heightValueLabel.text = [NSString stringWithFormat:@"%.2f ft",domeSize];
        longestStrutLengthLabel.text = [NSString stringWithFormat:@"%.2f ft",longestStrut];        
    }
    // capture ground of the dome for person to stand on
    domeSizeGround = topMargin+(domeCircleScale/2)*(1-domeHeightRatio)+ domeCircleScale*domeHeightRatio;
    // cut dome sphere to mimic dome shape
    [domeCircle setFrame:CGRectMake(sizeWindow.bounds.size.width/2-(domeCircleScale/2), topMargin+(domeCircleScale/2)*(1-domeHeightRatio), domeCircleScale, domeCircleScale*domeHeightRatio)];
    // new height of man relative to dome height
    CGFloat manHeight = (6/domeSize) * domeCircleScale*domeHeightRatio;
    [voyagerman setFrame:CGRectMake(sizeWindow.bounds.size.width/2-.2*manHeight, domeSizeGround-manHeight, .4*manHeight, manHeight)];
    [voyagercat setFrame:CGRectMake(sizeWindow.bounds.size.width/2-.5*.25*manHeight/.75, domeSizeGround-.25*manHeight, .25*manHeight/.75, .25*manHeight)];
    if (domeSize > 6)
    {
        [voyagercat setAlpha:0.0];
        [voyagerman setAlpha:1.0];
    }
    else if (domeSize > 5 && domeSize < 6)
    {
        [voyagercat setAlpha:(6.0-domeSize)];
        [voyagerman setAlpha:(domeSize-5.0)];
    }
    else
    {
        [voyagercat setAlpha:1.0];
        [voyagerman setAlpha:0.0];
    }
    
    [modelButton setBounds:CGRectMake(0, 0, 96, 70)];
    [modelButton setFrame:CGRectMake(8, 29, 96, 70)];
    [sizeButton setBounds:CGRectMake(0, 0, 96, 90)];
    [sizeButton setFrame:CGRectMake(112, 29, 96, 90)];
    [instructionButton setBounds:CGRectMake(0, 0, 96, 70)];
    [instructionButton setFrame:CGRectMake(216, 29, 96, 70)];
    [coverup setFrame:CGRectMake(113, 105, 94, 1)];
    modelWindow.hidden = true;
    sizeWindow.hidden = false;
    instructionWindow.hidden = true;
    pageNumber.text = [NSString stringWithFormat:@"SIZE"];
    [strutNodeScrollView setHidden:TRUE];  // Close when leaving Instruction Window

}

-(IBAction)instructionButtonPress:(id)sender
{
    [modelButton setBounds:CGRectMake(0, 0, 96, 70)];
    [modelButton setFrame:CGRectMake(8, 29, 96, 70)];
    [sizeButton setBounds:CGRectMake(0, 0, 96, 70)];
    [sizeButton setFrame:CGRectMake(112, 29, 96, 70)];
    [instructionButton setBounds:CGRectMake(0, 0, 96, 90)];
    [instructionButton setFrame:CGRectMake(216, 29, 96, 90)];
    [coverup setFrame:CGRectMake(217, 105, 94, 1)];
    modelWindow.hidden = true;
    sizeWindow.hidden = true;
    instructionWindow.hidden = false;
    pageNumber.text = [NSString stringWithFormat:@"ASSEMBLY DIAGRAM"];
    // draw large diagram
    [diagramView importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
    [diagramView setScale:130];
    [diagramView setLineWidth:4.0];
    [diagramView setNeedsDisplay];

    nodeCountLabel.text = [NSString stringWithFormat:@"%d",[domeView getPointCount]];
    strutCountLabel.text = [NSString stringWithFormat:@"%d",[domeView getLineCount]];
}

-(void) updateSizeButton
{
    [domePreview setFrame:CGRectMake(25, 8+27*(1-[domeView getDomeHeight]), 54, 54*[domeView getDomeHeight])];
    [heightMarkerPreview setFrame:CGRectMake(10, 8+27*(1-[domeView getDomeHeight]), 10, 54*[domeView getDomeHeight])];
    [heightMarkerPreview setNeedsDisplay];
}

-(IBAction)toggleDomeHeightLockOn:(id)sender
{
    sizeLockMode = false;
    lockStrut.alpha = 0.17;
    lockHeight.alpha = 1.0;
}
-(IBAction)toggleStrutLengthLockOn:(id)sender
{
    sizeLockMode = true;
    lockHeight.alpha = 0.17;
    lockStrut.alpha = 1.0;
}

- (IBAction)frequencyValueChanged:(UIStepper *)sender {
    VNumber = [sender value];
    if(VNumber > 0){
        
        //if(alignToSlice) [domeView align];
        [domeView generate:VNumber];
        [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        
        //[self refreshHeight];
        [self updateSizeButton];
        if([domeView getDomeHeight]==1) FractionLabel.text = [NSString stringWithFormat:@"SPHERE"];
        else FractionLabel.text = [NSString stringWithFormat:@"DOME"];

        VLabel.text = [NSString stringWithFormat:@"%dV",VNumber];
    }
}

-(IBAction)autoAlignPress:(id)sender
{
    if(alignToSlice){
        alignToSlice = false;
        [sender setAlpha:.17];
    }
    else{
        alignToSlice = true;
        [sender setAlpha:.75];
    }
}

-(IBAction)polyButtonTouchDown:(id)sender
{
    if(icosahedron)
        [polyButton setImage:[UIImage imageNamed:@"polybutton_state0_on.png"]];
    else
        [polyButton setImage:[UIImage imageNamed:@"polybutton_state1_on.png"]];
}

-(IBAction)polyButtonTouchDragOff:(id)sender
{
    if(icosahedron)
        [polyButton setImage:[UIImage imageNamed:@"polybutton_state0.png"]];
    else
        [polyButton setImage:[UIImage imageNamed:@"polybutton_state1.png"]];
}

-(IBAction)solidChange:(id)sender
{
    //if(alignToSlice) [domeView align];
    if(icosahedron)
    {
        solidView.image = [UIImage imageNamed:@"octahedron_icon.png"];
        SolidLabel.text = [NSString stringWithFormat:@"OCTAHEDRON"];
        [polyButton setImage:[UIImage imageNamed:@"polybutton_state1.png"]];
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
        [polyButton setImage:[UIImage imageNamed:@"polybutton_state0.png"]];
        icosaButton.enabled = false;
        octaButton.enabled = true;
        icosahedron = true;
        stepper.maximumValue = 9;
        [domeView.dome setIcosahedron];
        [diagramPreview.dome setIcosahedron];
        [domeView generate:VNumber];
        [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
    }
    [self updateSizeButton];
}

-(IBAction)strutButtonPress:(id)sender
{
    [strutNodeScrollView setHidden:TRUE];
    
    strutNodeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, self.view.frame.size.height/5*2+20)];
    [strutNodeScrollView setContentSize:CGSizeMake(strutNodeScrollView.frame.size.width, 1000)];
    UIView *window = [[UIView alloc] initWithFrame:CGRectMake(0, 0, strutNodeScrollView.frame.size.width, strutNodeScrollView.frame.size.height*2)];
    [window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    [window.layer setCornerRadius:7.0f];
    window.layer.borderColor = [UIColor lightGrayColor].CGColor;
    window.layer.borderWidth = 1.0;
    window.layer.masksToBounds = TRUE;
    [strutNodeScrollView addSubview:window];
    
    int StrutScale = 5;
    NSArray *speciesCount = [[NSArray alloc] initWithArray:[domeView getVisibleLineSpeciesCount]];
    NSMutableArray *lineLabels = [[NSMutableArray alloc] init];
    NSMutableArray *lengthLabels = [[NSMutableArray alloc] init];
    NSMutableArray *lengthOrder = [[NSMutableArray alloc] initWithArray:[domeView getLengthOrder]];
    int i, j, index;
    //lineclasslengths_.count = how many types of struts there are
    for(i = 0; i < diagramView.dome.lineClassLengths_.count; i++) [lengthOrder addObject:[[NSNumber alloc] initWithInt:0]];
    for(i = 0; i < diagramView.dome.lineClassLengths_.count; i++){
        index = 0;
        for(j = 0; j < diagramView.dome.lineClassLengths_.count; j++){
            if(i!=j && [diagramView.dome.lineClassLengths_[i] doubleValue] > [diagramView.dome.lineClassLengths_[j] doubleValue]) index++;
        }
        lengthOrder[index] = [[NSNumber alloc] initWithInt:i];
    }
    //NSLog(@"Step 1, Lengths tallied");

    //fit scrollview window
    [strutNodeScrollView setContentSize:CGSizeMake(strutNodeScrollView.frame.size.width, diagramView.dome.lineClassLengths_.count*30+20)];
    [window setFrame:CGRectMake(0, 0, strutNodeScrollView.frame.size.width, diagramView.dome.lineClassLengths_.count*30+20)];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 100, 23)];
    [textField setBorderStyle:UITextBorderStyleBezel];
    //[strutData addSubview:textField];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    
    NSMutableArray *strutLineExamples = [[NSMutableArray alloc] init];
    for(i = 0; i < diagramView.dome.lineClassLengths_.count; i++)
    {
        //index will count a little different from i, it counts in order of strut length
        index = i;//[lengthOrder[i] integerValue];
        [strutLineExamples addObject:[[UIView alloc] initWithFrame:
                                      CGRectMake(110-130*[diagramView.dome.lineClassLengths_[index] doubleValue],
                                                 index*30+14+10,
                                                 130*[diagramView.dome.lineClassLengths_[index] doubleValue],
                                                 3)]];
        if(index < diagramView.colorTable.count-1)
            [(UIView*)strutLineExamples[i] setBackgroundColor:diagramView.colorTable[index]];
        else
            [(UIView*)strutLineExamples[i] setBackgroundColor:diagramView.colorTable[diagramView.colorTable.count-1]];

        [window addSubview:strutLineExamples[i]];
    }
   // NSLog(@"Step 2, Struts drawn");

    for(i = 0; i < diagramView.dome.lineClassLengths_.count; i++)
    {
        //index will count a little different from i, it counts in order of strut length
        index = i;//[lengthOrder[i] integerValue];
        [lineLabels addObject:[[UILabel alloc] initWithFrame:CGRectMake(window.frame.size.width-60, 10+index*30, 100, 30)]];
 
        if(index < diagramView.colorTable.count-1)
            [(UILabel*)lineLabels[i] setTextColor:diagramView.colorTable[index]];
        else
            [(UILabel*)lineLabels[i] setTextColor:diagramView.colorTable[diagramView.colorTable.count-1]];
        
        [(UILabel*)lineLabels[i] setBackgroundColor:[UIColor clearColor]];
        [(UILabel*)lineLabels[i] setText:[NSString stringWithFormat:@"x %@",speciesCount[index]]];
        [(UILabel*)lineLabels[i] setFont:[UIFont boldSystemFontOfSize:21.0]];
        [window addSubview:lineLabels[i]];
        //NSLog(@"Length: %@",diagramView.dome.lineClassLengths_[i]);
        
        [lengthLabels addObject:[[UILabel alloc] initWithFrame:CGRectMake(window.frame.size.width-164,10+index*30, 100, 30)]];
        [(UILabel*)lengthLabels[i] setTextColor:[UIColor blackColor]];
        [(UILabel*)lengthLabels[i] setBackgroundColor:[UIColor clearColor]];
        [(UILabel*)lengthLabels[i] setFont:[UIFont boldSystemFontOfSize:21.0]];
        [(UILabel*)lengthLabels[i] setText:[NSString stringWithFormat:@"%.05f ft",[diagramView.dome.lineClassLengths_[index] doubleValue] * StrutScale]];
        [window addSubview:lengthLabels[i]];
    }    
  //  NSLog(@"Step 3, Text up, all done!");
    
    [instructionWindow addSubview:strutNodeScrollView];
}

/*-(IBAction)nodeButtonPress:(id)sender
{
    [strutNodeScrollView setHidden:TRUE];

    strutNodeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, self.view.frame.size.height/5*1)];
    [strutNodeScrollView setContentSize:CGSizeMake(strutNodeScrollView.frame.size.width, strutNodeScrollView.frame.size.height)];
    UIView *window = [[UIView alloc] initWithFrame:CGRectMake(0, 0, strutNodeScrollView.frame.size.width, strutNodeScrollView.frame.size.height)];
    [window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    [window.layer setCornerRadius:7.0f];
    window.layer.borderColor = [UIColor lightGrayColor].CGColor;
    window.layer.borderWidth = 1.0;
    window.layer.masksToBounds = TRUE;
    [strutNodeScrollView addSubview:window];
    
    [instructionWindow addSubview:strutNodeScrollView];
}*/

-(void) tapTwiceListener:(UITapGestureRecognizer*)sender
{
    //NSLog(@"%f %f",domeView.bounds.origin.x, domeView.bounds.origin.y);
    //if (CGRectContainsPoint(domeView.frame, [sender locationInView:self.view]))
    if(modelWindow.hidden == false)
        [self toggleSliceMode];
}

// Only purpose, to close the STRUT and NODE view windows
-(void) tapListener:(UITapGestureRecognizer*)sender
{
    if(instructionWindow.hidden == FALSE)
        [strutNodeScrollView setHidden:TRUE];
}

-(void) pinchListener:(UIPinchGestureRecognizer*)sender
{
    //if (CGRectContainsPoint(domeView.frame, [sender locationInView:self.view]))
    if(modelWindow.hidden == false)
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

    //NSLog(@"%d",[sender state]);
    if([sender state] == 1) touchOrigin = [sender locationInView:modelWindow];
    CGPoint translation = [sender translationInView:self.view];

    if(modelWindow.hidden == false)
    {
        if (CGRectContainsPoint(domeView.frame, touchOrigin))
        {
            if([domeView getSliceMode])
            {
                if([sender state] == 1) touchPanEdit = [domeView getSliceY];
                double sliceLocation = touchPanEdit+translation.y/[domeView getScale];
                if(sliceLocation < -2) [domeView setSliceY:-2];
                else if (sliceLocation > 2) [domeView setSliceY:2];
                else [domeView setSliceY:sliceLocation];
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
    else if(sizeWindow.hidden == false && domeHeightRatio != 0)
    {
        if([sender state] == 1) touchPanSize = domeSize;
        domeSize = touchPanSize * pow(touchPanSize,(translation.y/2000.0));
        longestStrut = domeSize / domeHeightRatio * longestStrutRatio;
        if(domeSize > 1000) { /* gotta cut off somewhere */
            domeSize = 1000;
            longestStrut = domeSize / domeHeightRatio * longestStrutRatio;
        }   
        heightValueLabel.text = [NSString stringWithFormat:@"%.2f ft",domeSize];
        longestStrutLengthLabel.text = [NSString stringWithFormat:@"%.2f ft", longestStrut];
        CGFloat manHeight = (6/domeSize) * domeCircleScale*[domeView getDomeHeight];
        [voyagerman setFrame:CGRectMake(sizeWindow.bounds.size.width/2-.2*manHeight, domeSizeGround-manHeight, .4*manHeight, manHeight)];
        [voyagercat setFrame:CGRectMake(sizeWindow.bounds.size.width/2-.5*.25*manHeight/.75, domeSizeGround-.25*manHeight, .25*manHeight/.75, .25*manHeight)];
       // NSLog(@"%f",domeSize);
        if (domeSize > 6)
        {
            [voyagercat setAlpha:0.0];
            [voyagerman setAlpha:1.0];
        }
        else if (domeSize > 5 && domeSize < 6)
        {
            [voyagercat setAlpha:(6.0-domeSize)];
            [voyagerman setAlpha:(domeSize-5.0)];
        }
        else
        {
            [voyagercat setAlpha:1.0];
            [voyagerman setAlpha:0.0];
        }

    }
}

-(void) toggleSliceMode
{
    // turn slice mode off
    if([domeView getSliceMode]){
        [cropButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cropButton.layer setCornerRadius:7.0f];
        cropButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cropButton.layer.borderWidth = 1.0;
        domeView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        [domeView capturePoles];    // capture the new orientation of the sphere
        [domeView setSliceMode:false];
        // refresh instruction tab bar button image
        [diagramPreview importDome:domeView.dome Polaris:domeView.polaris Octantis:domeView.octantis];
        [cropButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        if([domeView getDomeHeight] == 1) FractionLabel.text = [NSString stringWithFormat:@"SPHERE"];
        else FractionLabel.text = [NSString stringWithFormat:@"DOME"];
        [self updateSizeButton];
    }
    // slice mode on
    else{
        domeView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
        cropButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0].CGColor;
        cropButton.layer.borderWidth = 3.0;
        [cropButton setTitleColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        if(alignToSlice) [domeView align];  // align dome if auto align is on
        [domeView setSliceMode:true];
        [cropButton setTitleColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0] forState:UIControlEventTouchDown];
    }
    [domeView refresh];  // draw green slice line
}

-(void)flashMessage:(NSString*)message {
    CAKeyframeAnimation *messageAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    NSArray *animationValues = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.8f],
                                [NSNumber numberWithFloat:0.0f],
                                nil];
    
    NSArray *animationTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.3],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    NSArray *animationTimingFunctions = [NSArray arrayWithObjects:
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                         nil];
    
    [messageAnimation setValues:animationValues];
    [messageAnimation setKeyTimes:animationTimes];
    [messageAnimation setTimingFunctions:animationTimingFunctions];
    
    messageAnimation.fillMode = kCAFillModeForwards;
    messageAnimation.removedOnCompletion = NO;
    messageAnimation.duration = 0.4;
    
    [self.view.layer addAnimation:messageAnimation forKey:@"animation"];
    //[savingText setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
