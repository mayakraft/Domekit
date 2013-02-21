//
//  InstructionsViewController.m
//  Domekit
//
//  Created by Robby on 2/9/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "InstructionsViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

@synthesize diagramView;
@synthesize domeImport;
@synthesize StrutScale;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    domeSize = 10;
    [diagramView setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height-66)];
    [diagramView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:diagramView];
    [self.view sendSubviewToBack:diagramView];
    [diagramView setScale:130];
    [diagramView setLineWidth:4.0];
    [diagramView setNeedsDisplay];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    
    StrutScale = 5;
    //StrutScale /= 2*sqrt( ((1 + sqrt(5)) / 2 ) + 2 );

    UILabel *nodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.bounds.size.height-70, 200, 30)];
    [nodeLabel setBackgroundColor:[UIColor clearColor]];
    [nodeLabel setTextColor:[UIColor blackColor]];
    [nodeLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    nodeLabel.text = [NSString stringWithFormat:@"NODES"];
    [self.view addSubview:nodeLabel];

    UILabel *strutLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.bounds.size.height-40, 200, 30)];
    [strutLabel setBackgroundColor:[UIColor clearColor]];
    [strutLabel setTextColor:[UIColor blackColor]];
    [strutLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    strutLabel.text = [NSString stringWithFormat:@"STRUTS"];
    [self.view addSubview:strutLabel];

    //UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.bounds.size.height-40, 200, 30)];
    //[faceLabel setBackgroundColor:[UIColor clearColor]];
    //[faceLabel setTextColor:[UIColor blackColor]];
    //[faceLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    //faceLabel.text = [NSString stringWithFormat:@"FACES"];
    //[self.view addSubview:faceLabel];
   
    UILabel *nodeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, self.view.bounds.size.height-70, 75, 30)];
    [nodeCountLabel setBackgroundColor:[UIColor clearColor]];
    [nodeCountLabel setTextColor:[UIColor blackColor]];
    [nodeCountLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    [nodeCountLabel setTextAlignment:NSTextAlignmentRight];
    nodeCountLabel.text = [NSString stringWithFormat:@"%d",[diagramView getPointCount]];
    [self.view addSubview:nodeCountLabel];
    
    UILabel *strutCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, self.view.bounds.size.height-40, 75, 30)];
    [strutCountLabel setBackgroundColor:[UIColor clearColor]];
    [strutCountLabel setTextColor:[UIColor blackColor]];
    [strutCountLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
    [strutCountLabel setTextAlignment:NSTextAlignmentRight];
    strutCountLabel.text = [NSString stringWithFormat:@"%d",[diagramView getLineCount]];
    [self.view addSubview:strutCountLabel];
    
    UIButton *nodeButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [nodeButton setFrame:CGRectMake(7, self.view.bounds.size.height-70, 30, 30)];
    //[[UIButton alloc] initWithFrame:CGRectMake(7, self.view.bounds.size.height-100, 30, 30)];
    //[nodeButton setBackgroundColor:[UIColor clearColor]];
    //[nodeButton setTitle:[NSString stringWithFormat:@"▶"] forState:UIControlStateNormal];
    //[nodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:nodeButton];
    
    UIButton *strutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [strutButton setFrame:CGRectMake(7, self.view.bounds.size.height-40, 30, 30)];
    [self.view addSubview:strutButton];
    [strutButton addTarget:self action:@selector(strutDetailPress:) forControlEvents:UIControlEventTouchUpInside];

    //UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[faceButton setFrame:CGRectMake(7, self.view.bounds.size.height-40, 30, 30)];
    //[self.view addSubview:faceButton];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [self.view bounds].size.height-224, [self.view bounds].size.width, 224)];
    
    nodeData = [[UIView alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 200)];
    strutData = [[UIView alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 200)];
    faceData = [[UIView alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 200)];
    
    [strutData setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    
   // NSLog(@"%f",[diagramView getDomeHeight]);

    /*UILabel *pointCountLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/5.0*3.0, [[UIScreen mainScreen] bounds].size.height-140, 200, 30)];
    [pointCountLabel setBackgroundColor:[UIColor clearColor]];
    [pointCountLabel setTextColor:[UIColor blackColor]];
    pointCountLabel.text = [NSString stringWithFormat:@"HUBS (%d)",[diagramView getPointCount]];
    [self.view addSubview:pointCountLabel];
*/
    NSArray *speciesCount = [[NSArray alloc] initWithArray:[diagramView getVisibleLineSpeciesCount]];
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
    }
    //NSLog(@"LengthOrder Count: %d",lengthOrder.count);
    //for(i = 0; i < lengthOrder.count; i++) NSLog(@"%d",[lengthOrder[i] intValue]);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 100, 23)];
    [textField setBorderStyle:UITextBorderStyleBezel];
    //[strutData addSubview:textField];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    
    NSMutableArray *strutLineExamples = [[NSMutableArray alloc] init];
    for(i = 0; i < speciesCount.count; i++)
    {
        index = [lengthOrder[i] integerValue];
        [strutLineExamples addObject:[[UIView alloc] initWithFrame:
                                      CGRectMake(160-160*[diagramView.dome.lineClassLengths_[i] doubleValue],
                                                 index*23+14,
                                                 160*[diagramView.dome.lineClassLengths_[i] doubleValue],
                                                 3)]];
        if(index == 0)[(UIView*)strutLineExamples[i] setBackgroundColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0]];
        if(index == 1)[(UIView*)strutLineExamples[i] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0]];
        if(index == 2)[(UIView*)strutLineExamples[i] setBackgroundColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
        if(index == 3)[(UIView*)strutLineExamples[i] setBackgroundColor:[UIColor colorWithRed:0.8 green:0 blue:0.8 alpha:1.0]];
        if(index == 4)[(UIView*)strutLineExamples[i] setBackgroundColor:[UIColor colorWithRed:0 green:0.8 blue:0.8 alpha:1.0]];
        if(index == 5)[(UIView*)strutLineExamples[i] setBackgroundColor:[UIColor blackColor]];
        [strutData addSubview:strutLineExamples[i]];
    }
    for(i = 0; i < speciesCount.count; i++)
    {
        index = [lengthOrder[i] integerValue];
        [lineLabels addObject:[[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-50, index*23, 100, 30)]];
        if(index == 0)[(UILabel*)lineLabels[i] setTextColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0]];
        if(index == 1)[(UILabel*)lineLabels[i] setTextColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0]];
        if(index == 2)[(UILabel*)lineLabels[i] setTextColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
        if(index == 3)[(UILabel*)lineLabels[i] setTextColor:[UIColor colorWithRed:0.8 green:0 blue:0.8 alpha:1.0]];
        if(index == 4)[(UILabel*)lineLabels[i] setTextColor:[UIColor colorWithRed:0 green:0.8 blue:0.8 alpha:1.0]];

        [(UILabel*)lineLabels[i] setBackgroundColor:[UIColor clearColor]];
        [(UILabel*)lineLabels[i] setText:[NSString stringWithFormat:@"x %@",speciesCount[index]]];
        [(UILabel*)lineLabels[i] setFont:[UIFont boldSystemFontOfSize:17.0]];
        [strutData addSubview:lineLabels[i]];
        //NSLog(@"Length: %@",diagramView.dome.lineClassLengths_[i]);

        [lengthLabels addObject:[[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-140,index*23, 100, 30)]];
        [(UILabel*)lengthLabels[i] setTextColor:[UIColor blackColor]];
        [(UILabel*)lengthLabels[i] setBackgroundColor:[UIColor clearColor]];
        [(UILabel*)lengthLabels[i] setText:[NSString stringWithFormat:@"%.05f ft",[diagramView.dome.lineClassLengths_[i] doubleValue] * StrutScale]];
        [strutData addSubview:lengthLabels[i]];
    }
    
    
    [strutData setFrame:CGRectMake(0, self.view.bounds.size.height-(100+15+23*speciesCount.count), self.view.bounds.size.width, 100+15+23*speciesCount.count )];

    //strutData.layer.masksToBounds = TRUE;
    strutData.layer.borderColor = [UIColor blackColor].CGColor;
    strutData.layer.borderWidth = 3;
    
    polarizingFilter = [[UIView alloc] initWithFrame:[self.view bounds]];
    [polarizingFilter setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
    [polarizingFilter setAlpha:0.16];
    //[self.view addSubview:polarizingFilter];
    
    scaleWindow = [[UIView alloc] initWithFrame:CGRectMake(0, [self.view bounds].size.height-224, [self.view bounds].size.width, 224)];
    [scaleWindow setBackgroundColor:[UIColor clearColor]];
    //[self.view addSubview:scaleWindow];
    /*
    UIButton *scaleTitleButton = [[UIButton alloc] initWithFrame:CGRectMake([self.view bounds].size.width/2-40, 0, 80, 30)];
    [scaleTitleButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    scaleTitleButton.layer.masksToBounds = TRUE;
    scaleTitleButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    scaleTitleButton.layer.borderWidth = 3;
    [scaleTitleButton setTitle:[NSString stringWithFormat:@"SCALE"] forState:UIControlStateNormal];
    [scaleTitleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [scaleTitleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [scaleTitleButton.layer setCornerRadius:7.0f];
    [scaleTitleButton addTarget:self action:@selector(scalePress:) forControlEvents:UIControlEventTouchUpInside];
    [scaleWindow addSubview:scaleTitleButton];

    UIView *scaleBody = [[UIView alloc] initWithFrame:CGRectMake(-3, 24, [self.view bounds].size.width+6, 203)];
    [scaleBody setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    scaleBody.layer.masksToBounds = TRUE;
    scaleBody.layer.borderColor = [UIColor lightGrayColor].CGColor;
    scaleBody.layer.borderWidth = 3;
    [scaleWindow addSubview:scaleBody];

    UIView *coverup = [[UIView alloc] initWithFrame:CGRectMake([self.view bounds].size.width/2-37, 24, 74, 3)];
    [coverup setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    [scaleWindow addSubview:coverup];

  */
    domeCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle.png"]];
    domeCircle.frame = CGRectMake(self.view.bounds.size.width/2, 100+15+23*speciesCount.count-100, 86, 86*[diagramView getDomeHeight]);
    domeCircle.contentMode = UIViewContentModeTopLeft; // This determines position of image
    domeCircle.clipsToBounds = YES;
    //[strutData addSubview:domeCircle];
    
    //heightMarker = [[HeightMarker alloc] initWithFrame:CGRectMake(5, scaleWindow.bounds.size.height/2-43, 15, 86)];
    //[heightMarker setBackgroundColor:[UIColor clearColor]];
    //[scaleWindow addSubview:heightMarker];
    //[scaleWindow bringSubviewToFront:heightMarker];

    voyagerman = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagermandark.png"]];
    voyagerman.frame = CGRectMake(0,0,domeCircle.bounds.size.height*.4,domeCircle.bounds.size.height);
    voyagerman.alpha = .4;
    voyagercat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagercatdark.png"]];
    voyagercat.frame = CGRectMake(0,0,domeCircle.bounds.size.height*.3,domeCircle.bounds.size.height*.3*.75);
    voyagercat.alpha = 0;
    scaleFigureView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-43, 86, 86)];
    scaleFigureView.backgroundColor = [UIColor clearColor];
    scaleFigureView.hidden = FALSE;
    scaleFigureView.clipsToBounds = YES;
    [scaleFigureView addSubview:voyagerman];
    [scaleFigureView addSubview:voyagercat];
    //[scaleWindow addSubview:scaleFigureView];
    /*
    UIButton *makeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [makeButton setFrame:CGRectMake(scaleWindow.bounds.size.width-100,scaleWindow.bounds.size.height-40,80,30)];
    [makeButton setTitle:[NSString stringWithFormat:@"make"] forState:UIControlStateNormal];
    [makeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    makeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [scaleWindow addSubview:makeButton];
    [makeButton addTarget:self action:@selector(makePress:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWindow.bounds.size.width-120,34,100,40)];
    heightLabel.text = [NSString stringWithFormat:@"HEIGHT: "];
    heightLabel.font = [UIFont systemFontOfSize:12.0];
    heightLabel.textColor = [UIColor blackColor];
    [heightLabel setBackgroundColor:[UIColor clearColor]];
    //[scaleWindow addSubview:heightLabel];
    
    [self refreshHeight];
}

-(IBAction) makePress:(id)sender
{
    [scaleWindow setFrame:CGRectMake(0, [self.view bounds].size.height-24, [self.view bounds].size.width, 224)];
    [polarizingFilter setAlpha:0.0];
}

-(IBAction) scalePress:(id)sender
{
    [scaleWindow setFrame:CGRectMake(0, [self.view bounds].size.height-224, [self.view bounds].size.width, 224)];
    [polarizingFilter setAlpha:0.16];
}

-(IBAction) nodeDetailPress:(id)sender
{
    
}

-(IBAction) strutDetailPress:(id)sender
{
    [self.view addSubview:strutData];
}
-(void) refreshHeight
{
    int height = 86 * [diagramView getDomeHeight];
    domeCircle.frame = CGRectMake(20, scaleWindow.bounds.size.height/2-43+(86-height), 86, height);
    //sizeLabel.text = [NSString stringWithFormat:@"%.2f",(domeSize*[diagramView getDomeHeight])];
    //heightMarker.frame = CGRectMake(5, scaleWindow.bounds.size.height/2-43+(86-height), 15, height);
    //[heightMarker setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
