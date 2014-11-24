//
//  SimpleTableCellTableViewCell.m
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 11/23/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell
@synthesize eventLabel = _nameLabel;
@synthesize timeLabel = _prepTimeLabel;
@synthesize thumbNailImageView = _thumbNailImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
