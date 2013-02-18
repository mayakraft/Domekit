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

@interface InstructionsViewController : UIViewController
{
    Dome *domeImport;
    DiagramView *diagramView;
    int StrutScale;
}

@property (nonatomic,strong) IBOutlet DiagramView *diagramView;
@property Dome *domeImport;
@property int StrutScale;

@end
