//
//  ScaleFigureView.h
//  Domekit
//
//  Created by Robby on 6/7/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleFigureView : UIView
@property (nonatomic) float sessionScale;
@property (nonatomic) BOOL meters;
@property (nonatomic) float domeHeight;  // 0.0 (bottom) to 1.0 (top)
@end
