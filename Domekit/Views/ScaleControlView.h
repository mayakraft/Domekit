//
//  ScaleControlView.h
//  Domekit
//
//  Created by Robby on 5/8/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeodesicViewController.h"

@interface ScaleControlView : UIView <UITextFieldDelegate>
@property UISlider *slider;
@property UITextField *floorDiameterTextField;
@property UITextField *heightTextField;
@property UITextField *strutTextField;

@property (weak) GeodesicViewController *viewController;
@end
