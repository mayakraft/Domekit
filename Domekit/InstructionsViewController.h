//
//  InstructionsViewController.h
//  Domekit
//
//  Created by Robby on 2/9/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiagramView.h"
#import "Dome.h"
#import "HeightMarker.h"

@interface InstructionsViewController : UIViewController
{
    Dome *domeImport;
    DiagramView *diagramView;
    int StrutScale;
    UIView *scaleFigureView;
    UIImageView *voyagerman;
    UIImageView *voyagercat;
    UIImageView *domeCircle;
    //HeightMarker *heightMarker;
    UIView *scaleWindow;
    CGFloat domeSize;
    UIView *polarizingFilter;
    UIScrollView *scrollView;
    UIView *strutData;
    UIView *nodeData;
    UIView *faceData;
}

@property (nonatomic,strong) IBOutlet DiagramView *diagramView;
@property Dome *domeImport;
@property int StrutScale;

@end
