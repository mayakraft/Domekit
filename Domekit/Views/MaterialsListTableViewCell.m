//
//  MaterialsListTableViewCell.m
//  Domekit
//
//  Created by Robby on 5/19/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "MaterialsListTableViewCell.h"

@implementation MaterialsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void) layoutSubviews{
    [super layoutSubviews];
    if(_indented)
        [self.textLabel setFrame:CGRectMake(88, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height)];
//    [self.detailTextLabel setFrame:CGRectMake(self.frame.size.width - 88, self.detailTextLabel.frame.origin.y, 88, self.detailTextLabel.frame.size.height)];
}

@end
