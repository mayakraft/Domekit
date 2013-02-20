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
    [diagramView setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height-50)];
    [diagramView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:diagramView];
    [self.view sendSubviewToBack:diagramView];
    [diagramView setScale:130];
    [diagramView setLineWidth:4.0];
    [diagramView setNeedsDisplay];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.png"]]];
    
    //StrutScale = 30;
    StrutScale /= 2*sqrt( ((1 + sqrt(5)) / 2 ) + 2 );

    UILabel *lineCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, [[UIScreen mainScreen] bounds].size.height-140, 200, 30)];
    [lineCountLabel setBackgroundColor:[UIColor clearColor]];
    [lineCountLabel setTextColor:[UIColor blackColor]];
    lineCountLabel.text = [NSString stringWithFormat:@"STRUTS (x%d)",[diagramView getLineCount]];
    [self.view addSubview:lineCountLabel];

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
    
   
    for(i = 0; i < speciesCount.count; i++)
    {
        index = [lengthOrder[i] integerValue];
        [lineLabels addObject:[[UILabel alloc] initWithFrame:CGRectMake(67+100*(index%3), [[UIScreen mainScreen] bounds].size.height-115+(((int)(index/3.0))*23), 100, 30)]];

        [(UILabel*)lineLabels[i] setTextColor:[UIColor blackColor]];
        [(UILabel*)lineLabels[i] setBackgroundColor:[UIColor clearColor]];
        [(UILabel*)lineLabels[i] setText:[NSString stringWithFormat:@"x %@",speciesCount[index]]];
        [self.view addSubview:lineLabels[i]];
        //NSLog(@"Length: %@",diagramView.dome.lineClassLengths_[i]);

        [lengthLabels addObject:[[UILabel alloc] initWithFrame:CGRectMake(15+100*(index%3), [[UIScreen mainScreen] bounds].size.height-115+(((int)(index/3.0))*23), 100, 30)]];
        if(index == 0)[(UILabel*)lengthLabels[i] setTextColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0]];
        if(index == 1)[(UILabel*)lengthLabels[i] setTextColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0]];
        if(index == 2)[(UILabel*)lengthLabels[i] setTextColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
        if(index == 3)[(UILabel*)lengthLabels[i] setTextColor:[UIColor colorWithRed:0.8 green:0 blue:0.8 alpha:1.0]];
        if(index == 4)[(UILabel*)lengthLabels[i] setTextColor:[UIColor colorWithRed:0 green:0.8 blue:0.8 alpha:1.0]];
       //[(UILabel*)lengthLabels[i] setTextColor:[UIColor blackColor]];
        [(UILabel*)lengthLabels[i] setBackgroundColor:[UIColor clearColor]];
        [(UILabel*)lengthLabels[i] setText:[NSString stringWithFormat:@"%.02f ft",[diagramView.dome.lineClassLengths_[i] doubleValue] * StrutScale]];
        [self.view addSubview:lengthLabels[i]];
    }
    
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

  
    domeCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle.png"]];
    domeCircle.frame = CGRectMake(scaleWindow.bounds.size.width/2-86, scaleWindow.bounds.size.height/2-43+24, 86, 86);
    domeCircle.contentMode = UIViewContentModeTopLeft; // This determines position of image
    domeCircle.clipsToBounds = YES;
    [scaleWindow addSubview:domeCircle];
    
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
    scaleFigureView = [[UIView alloc] initWithFrame:CGRectMake(scaleWindow.bounds.size.width/2, scaleWindow.bounds.size.height/2-43, 86, 86)];
    scaleFigureView.backgroundColor = [UIColor clearColor];
    scaleFigureView.hidden = FALSE;
    scaleFigureView.clipsToBounds = YES;
    [scaleFigureView addSubview:voyagerman];
    [scaleFigureView addSubview:voyagercat];
    [scaleWindow addSubview:scaleFigureView];
    
    UIButton *makeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [makeButton setFrame:CGRectMake(scaleWindow.bounds.size.width-100,scaleWindow.bounds.size.height-40,80,30)];
    [makeButton setTitle:[NSString stringWithFormat:@"make"] forState:UIControlStateNormal];
    [makeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    makeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [scaleWindow addSubview:makeButton];
    [makeButton addTarget:self action:@selector(makePress:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWindow.bounds.size.width-120,34,100,40)];
    heightLabel.text = [NSString stringWithFormat:@"HEIGHT: "];
    heightLabel.font = [UIFont systemFontOfSize:12.0];
    heightLabel.textColor = [UIColor blackColor];
    [heightLabel setBackgroundColor:[UIColor clearColor]];
    [scaleWindow addSubview:heightLabel];*/
    
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
