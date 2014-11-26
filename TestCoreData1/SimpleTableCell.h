//
//  SimpleTableCellTableViewCell.h
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 11/23/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *whereLabel;

@property(nonatomic,retain) IBOutlet UITableViewCell *SimpleTableCell;
@property (nonatomic, weak) IBOutlet UILabel *eventLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbNailImageView;
@end
