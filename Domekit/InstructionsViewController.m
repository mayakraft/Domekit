//
//  InstructionsViewController.m
//  Domekit
//
//  Created by Robby on 2/9/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "InstructionsViewController.h"

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

    /*UILabel *lineCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, [[UIScreen mainScreen] bounds].size.height-140, 200, 30)];
    [lineCountLabel setBackgroundColor:[UIColor clearColor]];
    [lineCountLabel setTextColor:[UIColor blackColor]];
    lineCountLabel.text = [NSString stringWithFormat:@"STRUTS (x%d)",[diagramView getLineCount]];
    [self.view addSubview:lineCountLabel];
*/
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
    
    /* STRUT LENGTHS
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
    }*/
    
    UIView *sizeCalculatorView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.view bounds].size.height-120, [self.view bounds].size.width, 120)];
    [self.view addSubview:sizeCalculatorView];
    domeCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domecircle.png"]];
    domeCircle.frame = CGRectMake(20, sizeCalculatorView.bounds.size.height/2-43, 86, 86);
    domeCircle.contentMode = UIViewContentModeTopLeft; // This determines position of image
    domeCircle.clipsToBounds = YES;
    [sizeCalculatorView addSubview:domeCircle];
    [sizeCalculatorView sendSubviewToBack:domeCircle];
    
    heightMarker = [[HeightMarker alloc] initWithFrame:CGRectMake(5, sizeCalculatorView.bounds.size.height/2-43, 15, 86)];
    [heightMarker setBackgroundColor:[UIColor clearColor]];
    [sizeCalculatorView addSubview:heightMarker];
    [sizeCalculatorView bringSubviewToFront:heightMarker];

    voyagerman = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagermandark.png"]];
    voyagerman.frame = CGRectMake(0,0,domeCircle.bounds.size.height*.4,domeCircle.bounds.size.height);
    voyagerman.alpha = .4;
    voyagercat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagercatdark.png"]];
    voyagercat.frame = CGRectMake(0,0,domeCircle.bounds.size.height*.3,domeCircle.bounds.size.height*.3*.75);
    voyagercat.alpha = 0;
    scaleFigureView = [[UIView alloc] initWithFrame:CGRectMake(20+domeCircle.bounds.size.width, sizeCalculatorView.bounds.size.height/2-43, 86, 86)];
    scaleFigureView.backgroundColor = [UIColor clearColor];
    scaleFigureView.hidden = FALSE;
    scaleFigureView.clipsToBounds = YES;
    [scaleFigureView addSubview:voyagerman];
    [scaleFigureView addSubview:voyagercat];
    [sizeCalculatorView addSubview:scaleFigureView];
    
    UIButton *makeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [makeButton setFrame:CGRectMake(sizeCalculatorView.bounds.size.width-120,sizeCalculatorView.bounds.size.height/2-20,100,40)];
    [makeButton setTitle:[NSString stringWithFormat:@"make ▸"] forState:UIControlStateNormal];
    [makeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    makeButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [sizeCalculatorView addSubview:makeButton];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(sizeCalculatorView.bounds.size.width-120,sizeCalculatorView.bounds.size.height/2+30,100,40)];
    heightLabel.text = [NSString stringWithFormat:@"Height: "];
    heightLabel.font = [UIFont systemFontOfSize:20.0];
    heightLabel.textColor = [UIColor blackColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
