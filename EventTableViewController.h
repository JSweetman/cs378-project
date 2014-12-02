//
//  EventTableViewController.h
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 11/12/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface EventTableViewController : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSMutableArray *DataModelList;//@interface EventTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)addButton:(id)sender;

@end