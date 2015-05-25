//
//  ScaleControlView.m
//  Domekit
//
//  Created by Robby on 5/8/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "ScaleControlView.h"

#define MARGIN 10

@implementation ScaleControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self = [super init];
    if(self)
        [self initUI:UIScreen.mainScreen.bounds];
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
        [self initUI:UIScreen.mainScreen.bounds];
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
        [self initUI:frame];
    return self;
}

-(void) initUI:(CGRect)frame{
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(frame.size.width*.1, frame.size.height*.6, frame.size.width*.8, frame.size.height*.4)];
    [_slider setValue:.5];
    [self addSubview:_slider];
    
    _heightTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width*.5, frame.size.height*.15, frame.size.width*.425, frame.size.height*.15)];
    [_heightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_heightTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_heightTextField setText:@"15.125 ft"];
    [self addSubview:_heightTextField];

    _floorDiameterTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width*.5, frame.size.height*.3, frame.size.width*.425, frame.size.height*.15)];
    [_floorDiameterTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_floorDiameterTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_floorDiameterTextField setText:@"30.25 ft"];
    [self addSubview:_floorDiameterTextField];

    
    _strutTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width*.5, frame.size.height*.45, frame.size.width*.425, frame.size.height*.15)];
    [_strutTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_strutTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_strutTextField setText:@"1.75 ft"];
    [self addSubview:_strutTextField];

    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*.15, frame.size.width*.5 - MARGIN, frame.size.height*.15)];
    [heightLabel setText:@"Height:"];
    [heightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [heightLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:heightLabel];

    UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*.3, frame.size.width*.5 - MARGIN, frame.size.height*.15)];
    [floorLabel setText:@"Floor Diameter:"];
    [floorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [floorLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:floorLabel];

    UILabel *strutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*.45, frame.size.width*.5 - MARGIN, frame.size.height*.15)];
    [strutLabel setText:@"Longest Strut:"];
    [strutLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [strutLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:strutLabel];
    
    [_heightTextField setEnabled:NO];
    [_floorDiameterTextField setEnabled:NO];
    [_strutTextField setEnabled:NO];
}

@end
