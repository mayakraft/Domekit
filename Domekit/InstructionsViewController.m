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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
