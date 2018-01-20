//
//  ScaleControlView.m
//  Domekit
//
//  Created by Robby on 5/8/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "ScaleControlView.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define MARGIN 10

@interface ScaleControlView ()
@property CGRect frame0;
@property UILabel *heightLabel;
@property UILabel *floorLabel;
@property UILabel *strutLabel;
@property UIView *whiteOverlay;
@property (weak) UITextField *selectedTextField;
@end


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
    if(self){
        [self initUI:UIScreen.mainScreen.bounds];
        if(IPAD)
            [self resizeForIpad:UIScreen.mainScreen.bounds];
        _frame0 = UIScreen.mainScreen.bounds;
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initUI:UIScreen.mainScreen.bounds];
        if(IPAD)
            [self resizeForIpad:UIScreen.mainScreen.bounds];
        _frame0 = UIScreen.mainScreen.bounds;
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI:frame];
        if(IPAD)
            [self resizeForIpad:frame];
        _frame0 = frame;
    }
    return self;
}

-(void) setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    [self enableControls];
    [self endEditing:YES];
}

-(void) enableControls{
    [_heightTextField setTextColor:[UIColor blackColor]];
    [_floorDiameterTextField setTextColor:[UIColor blackColor]];
    [_strutTextField setTextColor:[UIColor blackColor]];
    [_slider setEnabled:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_slider setEnabled:NO];

    [_heightTextField setTextColor:[UIColor lightGrayColor]];
    [_floorDiameterTextField setTextColor:[UIColor lightGrayColor]];
    [_strutTextField setTextColor:[UIColor lightGrayColor]];
    [textField setTextColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([[textField text] floatValue] > 0.0){
        if([textField isEqual:_heightTextField])
            [_viewController userInputHeight:[[textField text] floatValue]];
        if([textField isEqual:_floorDiameterTextField])
            [_viewController userInputFloorDiameter:[[textField text] floatValue]];
        if([textField isEqual:_strutTextField])
            [_viewController userInputLongestStrut:[[textField text] floatValue]];
    }
    [self enableControls];
    
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardWillShow:(NSNotification*)notification{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self setFrame:CGRectMake(_frame0.origin.x, _frame0.origin.y - keyboardRect.size.height, _frame0.size.width, _frame0.size.height)];
    [_whiteOverlay setAlpha:0.95];
    if(_viewController)
        [_viewController iOSKeyboardShow];
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [self setFrame:_frame0];
    [_whiteOverlay setAlpha:0.0];
    if(_viewController)
        [_viewController iOSKeyboardHide];
}

-(void) initUI:(CGRect)frame{
    
    _whiteOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [_whiteOverlay setBackgroundColor:[UIColor whiteColor]];
    [_whiteOverlay setAlpha:0.0];
    [self addSubview:_whiteOverlay];

    _slider = [[UISlider alloc] initWithFrame:CGRectMake(frame.size.width*.1, frame.size.height*.6, frame.size.width*.8, frame.size.height*.4)];
    [_slider setValue:.5];
	_slider.accessibilityLabel = @"adjust size";
    [self addSubview:_slider];
    
    _heightTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width*.5, frame.size.height*.15, frame.size.width*.425, frame.size.height*.15)];
//    [_heightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_heightTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_heightTextField setText:@""];
    [_heightTextField setDelegate:self];
	_heightTextField.accessibilityLabel = @"dome height";
	_heightTextField.accessibilityTraits = UIAccessibilityTraitAdjustable;
    [self addSubview:_heightTextField];

    _floorDiameterTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width*.5, frame.size.height*.3, frame.size.width*.425, frame.size.height*.15)];
//    [_floorDiameterTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_floorDiameterTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_floorDiameterTextField setText:@""];
    [_floorDiameterTextField setDelegate:self];
	_floorDiameterTextField.accessibilityLabel = @"floor diameter";
	_floorDiameterTextField.accessibilityTraits = UIAccessibilityTraitAdjustable;
    [self addSubview:_floorDiameterTextField];

    
    _strutTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width*.5, frame.size.height*.45, frame.size.width*.425, frame.size.height*.15)];
//    [_strutTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_strutTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_strutTextField setText:@""];
    [_strutTextField setDelegate:self];
	_strutTextField.accessibilityLabel = @"longest strut";
	_strutTextField.accessibilityTraits = UIAccessibilityTraitAdjustable;
    [self addSubview:_strutTextField];

    
//    [_strutTextField setKeyboardType:UIKeyboardTypeDecimalPad];
//    [_heightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
//    [_floorDiameterTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_strutTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_heightTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_floorDiameterTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_strutTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_heightTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_floorDiameterTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
 
    _heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*.15, frame.size.width*.5 - MARGIN, frame.size.height*.15)];
    [_heightLabel setText:@"Height:"];
    [_heightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_heightLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_heightLabel];

    _floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*.3, frame.size.width*.5 - MARGIN, frame.size.height*.15)];
    [_floorLabel setText:@"Floor Diameter:"];
    [_floorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_floorLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_floorLabel];

    _strutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*.45, frame.size.width*.5 - MARGIN, frame.size.height*.15)];
    [_strutLabel setText:@"Longest Strut:"];
    [_strutLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_strutLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_strutLabel];
}

-(void) resizeForIpad:(CGRect)frame{
    [_slider setFrame:CGRectMake(frame.size.width*.1, frame.size.height*.8, frame.size.width*.8, frame.size.height*.2)];
    [_heightTextField setFrame:CGRectMake(frame.size.width*.5, frame.size.height*.5, frame.size.width*.3, frame.size.height*.1)];
    [_floorDiameterTextField setFrame:CGRectMake(frame.size.width*.5, frame.size.height*.6, frame.size.width*.3, frame.size.height*.1)];
    [_strutTextField setFrame:CGRectMake(frame.size.width*.5, frame.size.height*.7, frame.size.width*.3, frame.size.height*.1)];
    
    [_heightLabel setFrame:CGRectMake(0, frame.size.height*.5, frame.size.width*.5 - MARGIN, frame.size.height*.1)];
    [_heightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    [_floorLabel setFrame:CGRectMake(0, frame.size.height*.6, frame.size.width*.5 - MARGIN, frame.size.height*.1)];
    [_floorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    [_strutLabel setFrame:CGRectMake(0, frame.size.height*.7, frame.size.width*.5 - MARGIN, frame.size.height*.1)];
    [_strutLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
}


@end
