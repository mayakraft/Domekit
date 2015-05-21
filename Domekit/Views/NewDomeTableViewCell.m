//
//  NewDomeTableViewCell.m
//  Domekit
//
//  Created by Robby on 5/21/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "NewDomeTableViewCell.h"

#define revealWidth 260

@implementation NewDomeTableViewCell

-(void) setupButtons{
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, revealWidth * .5, 100)];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(revealWidth * .5, 0, revealWidth * .5, 100)];
    [_leftButton setTitle:@"Icosahedron" forState:UIControlStateNormal];
    [_rightButton setTitle:@"Octahedron" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_leftButton];
    [self addSubview:_rightButton];
}

-(id) init{
    self = [super init];
    if(self){
        [self setupButtons];
    }
    return self;
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupButtons];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupButtons];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupButtons];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void) layoutSubviews{
    [super layoutSubviews];
    [_leftButton setFrame:CGRectMake(0, 0, revealWidth * .5, 100)];
    [_rightButton setFrame:CGRectMake(revealWidth * .5, 0, revealWidth * .5, 100)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
