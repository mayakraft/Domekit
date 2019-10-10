//
//  NewDomeTableViewCell.m
//  Domekit
//
//  Created by Robby on 5/21/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "NewDomeTableViewCell.h"

#define revealWidth 260
#define cellHeight 120
#define MARGIN 5

@implementation NewDomeTableViewCell

-(void) setupButtons{
    NSString *icoFileName = @"icosahedron.png";
    NSString *octaFileName = @"octahedron.png";
    UIColor *textColor = [UIColor blackColor];
    if (@available(iOS 12.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
            icoFileName = @"icosahedron-dark.png";
            octaFileName = @"octahedron-dark.png";
            textColor = [UIColor whiteColor];
        } else {
        }
    } else {
    }

    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, revealWidth * .5-MARGIN*2, cellHeight-MARGIN*2)];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(revealWidth * .5+MARGIN, MARGIN, revealWidth * .5 - MARGIN*2, cellHeight - MARGIN*2)];
    [_leftButton setTitle:@"Icosahedron" forState:UIControlStateNormal];
    [_rightButton setTitle:@"Octahedron" forState:UIControlStateNormal];
    CGPoint center1 = CGPointMake(MARGIN + (revealWidth * .5-MARGIN*2)*.5, MARGIN + (cellHeight-MARGIN*2) * .5);
    CGPoint center2 = CGPointMake(revealWidth * .5+MARGIN + (revealWidth * .5 - MARGIN*2) * .5, MARGIN + (cellHeight - MARGIN*2)*.5);
    CGFloat imgSize = cellHeight * .66;
    UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(center1.x - imgSize*.5, center1.y-imgSize*.5 - MARGIN*2, imgSize, imgSize)];
    UIImageView *oct = [[UIImageView alloc] initWithFrame:CGRectMake(center2.x - imgSize*.5, center2.y-imgSize*.5 - MARGIN*2, imgSize, imgSize)];
    [ico setImage:[UIImage imageNamed:icoFileName]];
    [oct setImage:[UIImage imageNamed:octaFileName]];
    [self addSubview:ico];
    [self addSubview:oct];
    [_leftButton setTitleColor:textColor forState:UIControlStateNormal];
    [_rightButton setTitleColor:textColor forState:UIControlStateNormal];
    [_rightButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [self addSubview:_leftButton];
    [self addSubview:_rightButton];
    separatorLine = [[UIView alloc] initWithFrame:CGRectMake(revealWidth*.5, MARGIN, 1, cellHeight-MARGIN*2)];
    [separatorLine setBackgroundColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1]];
    [self addSubview:separatorLine];
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
	[super awakeFromNib];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    [_leftButton setFrame:CGRectMake(MARGIN, MARGIN, revealWidth * .5-MARGIN*2, cellHeight-MARGIN*2)];
    [_rightButton setFrame:CGRectMake(revealWidth * .5+MARGIN, MARGIN, revealWidth * .5 - MARGIN*2, cellHeight - MARGIN*2)];
    [separatorLine setFrame:CGRectMake(revealWidth*.5, MARGIN, 1, cellHeight-MARGIN*2)];
    
    if (@available(iOS 12.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
            [self setBackgroundColor:[UIColor blackColor]];
        } else {
            [self setBackgroundColor:[UIColor whiteColor]];
        }
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
