//
//  ViewController.h
//  Domekit
//
//  Created by Robby on 1/28/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DomeView.h"
#import "DiagramView.h"
#import "Point3D.h"

@interface ViewController : UIViewController
{
    
//MODEL VIEW
    DiagramView *diagramPreview;
    DomeView *domeView;
    Point3D *touchPanRotate;  // last position in pan during rotate mode
    CGFloat touchPanEdit;     // last position in pan during splice mode
    CGFloat touchPinch;       // last position in pinch to scale
    BOOL icosahedron;
    BOOL alignToSplice;        // auto-aligns dome before splicing
    int VNumber;
    UIView *coverup;
//SIZE VIEW
    UIView *sizeWindow;
    UIView *scaleFigureView;
    UIImageView *voyagerman;
    UIImageView *voyagercat;
    UIImageView *domeCircle;
    //CGFloat touchPanSize;     // last position in pan during size mode
    //BOOL sizeToggle;
    //CGFloat domeSize;
    //CGFloat touchDomeSize;     // last position of domeSize during size mode
//INSTRUCTION VIEW
    UIView *instructionWindow;
    DiagramView *diagramView;
    UIView *strutData;
    UIView *nodeData;
    UIView *faceData;
    UILabel *nodeCountLabel;
    UILabel *strutCountLabel;
}
@property IBOutlet UIButton *modelButton;
@property IBOutlet UIButton *sizeButton;
@property IBOutlet UIButton *instructionButton;
@property IBOutlet UILabel *pageNumber;
@property IBOutlet UIButton *cropButton;
@property IBOutlet UILabel *VLabel;
@property IBOutlet UILabel *FractionLabel;
@property IBOutlet UILabel *SolidLabel;
@property IBOutlet UIImageView *solidView;
@property IBOutlet UIStepper *stepper;
@property IBOutlet UIButton *icosaButton;
@property IBOutlet UIButton *octaButton;
@property IBOutlet UIView *modelWindow;

-(IBAction)modelButtonPress:(id)sender;
-(IBAction)sizeButtonPress:(id)sender;
-(IBAction)instructionButtonPress:(id)sender;
- (IBAction)valueChanged:(UIStepper *)sender;
-(IBAction)alignDomeButton:(id)sender;
-(IBAction)solidChange:(id)sender;


//@property IBOutlet UIButton *sizeButton;
//@property IBOutlet UILabel *sizeLabel;
//@property IBOutlet UILabel *sizeFPartLabel;
//@property IBOutlet UIView *sizeView;




@end
