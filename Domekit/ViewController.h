//
//  ViewController.h
//  Domekit
//
//  Created by Robby on 1/28/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property IBOutlet UIButton *modelButton;           //|
@property IBOutlet UIButton *sizeButton;            //| three tab bar buttons
@property IBOutlet UIButton *instructionButton;     //|
@property IBOutlet UIButton *aboveInstructionButton;     //|
@property IBOutlet UILabel *VLabel;             //|
@property IBOutlet UILabel *FractionLabel;      //| bottom status bar descriptions
@property IBOutlet UILabel *SolidLabel;         //|
@property IBOutlet UIImageView *solidView;  // polyhedron picture in model tab button
@property IBOutlet UILabel *pageNumber;   // status bar page description label
// model window page elements
@property IBOutlet UIView *modelWindow;
@property IBOutlet UIStepper *stepper;
@property IBOutlet UIButton *cropButton;
@property IBOutlet UIButton *icosaButton;
@property IBOutlet UIButton *octaButton;
@property IBOutlet UIImageView *polyButton;


-(IBAction)modelButtonPress:(id)sender;
-(IBAction)sizeButtonPress:(id)sender;
-(IBAction)instructionButtonPress:(id)sender;
-(IBAction)frequencyValueChanged:(UIStepper *)sender;
-(IBAction)autoAlignPress:(id)sender;
-(IBAction)solidChange:(id)sender;
-(IBAction)polyButtonTouchDown:(id)sender;
-(IBAction)toggleDomeHeightLockOn:(id)sender;
-(IBAction)toggleStrutLengthLockOn:(id)sender;

@end
