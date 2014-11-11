//
//  CDViewController.m
//  AlphaProject
//
//  Created by Robert Seitsinger on 9/30/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "CDViewController.h"
#import "CDAppDelegate.h"
#import "DataModel.h"
#import "IndivCDViewController.h"
#import <Parse/Parse.h>

@interface CDViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *DataModelList;

//@property(strong, nonatomic) DataModel *d1;

@end

@implementation CDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // create d1 object
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadModelData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadModelData
{
    // Fetch (read) the data
    self.DataModelList = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    NSArray *parse_list = [query findObjects];
    DataModel *dm = [[DataModel alloc] init];
    for (PFObject *obj in parse_list) {
        dm.event = obj[@"name"];
        NSLog(@"obj name: %@", obj[@"name"]);
        dm.where = obj[@"where"];
        dm.time = obj[@"time"];
        dm.food = obj[@"food"];
        [self.DataModelList addObject:dm];
    }
    for (DataModel *dm in self.DataModelList) {
        NSLog(@"object name for loop name: %@", dm.event);
    }
    
//    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
//    DataModel *dm = [[DataModel alloc] init];
//    PFObject *FoodEvent = [query getObjectWithId:@"2cKLLF7PEX"];
//    dm.event = FoodEvent[@"name"];
//    dm.where = FoodEvent[@"where"];
//    dm.time = FoodEvent[@"time"];
//    dm.food = FoodEvent[@"food"];
//    [self.DataModelList addObject:dm];
//    NSLog(@"loadmodeldata event : %@", dm.event);
//    NSLog(@"loadmodeldata datamodellist count: %lu@", [self.DataModelList count]);
}


    //LOOK need to go to AddViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Details"]){
        IndivCDViewController *vc = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        DataModel *contactToPass = self.DataModelList[path.row];
        vc.hey = contactToPass;
    }
        
}



// UiTableViewController data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.DataModelList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    
    // Configure the cell...
    DataModel* hi = [self.DataModelList objectAtIndex:indexPath.row];
    cell.textLabel.text = hi.event;
    cell.detailTextLabel.text = hi.where;
    return cell;
}

@end
