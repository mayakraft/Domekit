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
//    float startRatio = .6; // domes begin at 10 units, person is 6 ft tall.
    _humanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagerman.png"]];
    _catImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voyagercat.png"]];
    CGFloat aspectHuman = _humanImageView.frame.size.width / _humanImageView.frame.size.height;
    CGFloat aspectCat = _catImageView.frame.size.width / _catImageView.frame.size.height;
    [_humanImageView setFrame:CGRectMake(0, 0, self.frame.size.height * aspectHuman, self.frame.size.height)];
    [_catImageView setFrame:CGRectMake(0, 0, self.frame.size.height * .25 * aspectCat, self.frame.size.height * .25)];
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

    float unitScale = 1.0;
    if(_meters)
        unitScale = 0.3048;
    
    [_humanImageView.layer setAffineTransform:CGAffineTransformMakeScale(6.0 / _sessionScale * unitScale, 6.0 / _sessionScale * unitScale)];
    [_catImageView.layer setAffineTransform:CGAffineTransformMakeScale(6.0 / _sessionScale * unitScale, 6.0 / _sessionScale * unitScale)];
    
    if (_sessionScale * _domeHeight > 6.5 * unitScale)
    {
        [_catImageView setAlpha:0.0];
        [_humanImageView setAlpha:1.0];
    }
    else if (_sessionScale * _domeHeight > 5.5 * unitScale && _sessionScale * _domeHeight < 6.5 * unitScale)
    {
        float tween = (_sessionScale * _domeHeight / unitScale);
        [_catImageView setAlpha:(6.5-tween)];
        [_humanImageView setAlpha:(tween-5.5)];
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
