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

//@interface EventTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@end