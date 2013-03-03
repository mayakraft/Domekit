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
@property IBOutlet UIButton *aboveInstructionButton;//| (actual instruction button which receives IBAction
@property IBOutlet UILabel *VLabel;             //|
@property IBOutlet UILabel *FractionLabel;      //| status bar dome description
@property IBOutlet UILabel *SolidLabel;         //|
@property IBOutlet UIImageView *solidView;  // polyhedron picture in model tab bar button
@property IBOutlet UILabel *pageNumber;   // status bar page description label
@property IBOutlet UIView *modelWindow;   // together with sizeWindow, and instructionWindow = the 3 containers for each page
// model window page elements
@property IBOutlet UIStepper *stepper;  // Frequency  - / +
@property IBOutlet UIButton *cropButton;
@property IBOutlet UIButton *icosaButton;    //|
@property IBOutlet UIButton *octaButton;     //| polyhedra button
@property IBOutlet UIImageView *polyButton;  //|
@property IBOutlet UILabel *alignAlertMessage;

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
