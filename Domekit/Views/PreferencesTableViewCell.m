//
//  PreferencesTableViewCell.m
//  Domekit
//
//  Created by Robby on 5/20/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "PreferencesTableViewCell.h"

@implementation PreferencesTableViewCell

- (void)awakeFromNib {
    // Initialization code
	[super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews{
    [super layoutSubviews];
    if(_textColor)
        [[self textLabel] setTextColor:_textColor];
    if(_textAlignment){
        if([_textAlignment integerValue] == 0)
            [[self textLabel] setTextAlignment:NSTextAlignmentLeft];
        if([_textAlignment integerValue] == 1){
            [[self textLabel] setFrame:CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y,
                                                  self.frame.size.width-(2*self.textLabel.frame.origin.x), self.textLabel.frame.size.height)];
            [[self textLabel] setTextAlignment:NSTextAlignmentCenter];
        }
        if([_textAlignment integerValue] == 2){
            [[self textLabel] setFrame:CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y,
                                                  self.frame.size.width-(2*self.textLabel.frame.origin.x), self.textLabel.frame.size.height)];
            [[self textLabel] setTextAlignment:NSTextAlignmentRight];
        }
    }
}

@end
