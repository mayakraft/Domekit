//
//  ScaleFigureView.m
//  Domekit
//
//  Created by Robby on 6/7/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "ScaleFigureView.h"

@interface ScaleFigureView ()
@property UIImageView *humanImageView;
@property UIImageView *catImageView;
@end

@implementation ScaleFigureView
-(id) init{
    self = [super init];
    if(self){
        [self initUI];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}

-(void) initUI{
    NSString *imageManPath = @"voyagerman.png";
    NSString *imageCatPath = @"voyagercat.png";
    if (@available(iOS 12.0, *)) {
        if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
            imageManPath = @"voyagerman-dark.png";
            imageCatPath = @"voyagercat-dark.png";
        } else {
        }
    } else {
    }

    float humanCatRatio = .3; //.25;  // approximate the height of a person : height of a cat
    // but really it's the heigh of these images to each other, so it's not scientific
    
//    float startRatio = .6; // domes begin at 10 units, person is 6 ft tall.
    _humanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageManPath]];
    _catImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageCatPath]];
    CGFloat aspectHuman = _humanImageView.frame.size.width / _humanImageView.frame.size.height;
    CGFloat aspectCat = _catImageView.frame.size.width / _catImageView.frame.size.height;
    [_humanImageView setFrame:CGRectMake(0, 0, self.frame.size.height * aspectHuman, self.frame.size.height)];
    [_catImageView setFrame:CGRectMake(0, 0, self.frame.size.height * humanCatRatio * aspectCat, self.frame.size.height * humanCatRatio)];
    [_humanImageView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
    [_catImageView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
    [_humanImageView setCenter:CGPointMake(self.frame.size.width*.5, self.frame.size.height)];
    [_catImageView setCenter:CGPointMake(self.frame.size.width*.5, self.frame.size.height)];
    [self addSubview:_humanImageView];
    [self addSubview:_catImageView];
}

-(void) setDomeHeight:(float)domeHeight{
    _domeHeight = domeHeight;
    [self updateScales];
}

-(void) setSessionScale:(float)sessionScale{
    _sessionScale = sessionScale;
    [self updateScales];
}

-(void) setMeters:(BOOL)meters{
    _meters = meters;
    [self updateScales];
}

-(void) updateScales{
    [_humanImageView setCenter:CGPointMake(self.frame.size.width*.5, self.frame.size.height*_domeHeight)];
    [_catImageView setCenter:CGPointMake(self.frame.size.width*.5, self.frame.size.height*_domeHeight)];

    // feet and meters stuff
    float unitScale = 1.0;
    if(_meters)
        unitScale = 0.3048;

    // range of the fade between figures
    // the lower the number, the taller the figure gets before crossing the threshhold
    float CEILING = 4.5;
    float FLOOR = 4.0;

    float span = CEILING - FLOOR;
    
    [_humanImageView.layer setAffineTransform:CGAffineTransformMakeScale(6.0 / _sessionScale * unitScale, 6.0 / _sessionScale * unitScale)];
    [_catImageView.layer setAffineTransform:CGAffineTransformMakeScale(6.0 / _sessionScale * unitScale, 6.0 / _sessionScale * unitScale)];
    
    if (_sessionScale * _domeHeight > CEILING * unitScale)
    {
        [_catImageView setAlpha:0.0];
        [_humanImageView setAlpha:1.0];
    }
    else if (_sessionScale * _domeHeight > FLOOR * unitScale && _sessionScale * _domeHeight < CEILING * unitScale)
    {
        float tween = (_sessionScale * _domeHeight / unitScale);
        [_catImageView setAlpha:(CEILING-tween)/span];
        [_humanImageView setAlpha:(tween-FLOOR)/span];
    }
    else
    {
        [_catImageView setAlpha:1.0];
        [_humanImageView setAlpha:0.0];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
