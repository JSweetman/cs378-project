//
//  HappeningViewController.m
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 10/21/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "HappeningViewController.h"
#import <Parse/Parse.h>

@interface HappeningViewController ()
@property (strong, nonatomic) NSMutableArray *DataModelList;
@end

@implementation HappeningViewController

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"FoodEvent";
        [self loadModelData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"Food" forKey:@"channels"];
    [currentInstallation saveInBackground];
    //self.nowList = [NSMutableArray new];
    /*
    if ([_nowList count] == 0) {
        NSLog(@"No Matches");
    } else {
        NSManagedObject *item = nil;
        //LOOK
        for (int i = 0; i < [_nowList count]; i++) {
            item = _nowList[i];
            DataModel *dm = [[DataModel alloc] init];
            dm.event = [item valueForKey:@"event"];
            dm.where = [item valueForKey:@"where"];
            dm.pickedTime =[item valueForKey:@"pickedTime"];
            dm.pickedDate =[item valueForKey:@"pickeDate"];
            dm.food =[item valueForKey:@"food"];
            [self.DataModelList addObject: dm];
        }
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadModelData
{
    self.nowList = [NSMutableArray new];
    
    self.DataModelList = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    [query addAscendingOrder:@"pickedDate"];
    [query addAscendingOrder:@"pickedTime"];
    //[query orderByAscending:@"pickedTime"];
    NSArray *parse_list = [query findObjects];
    
    for (PFObject *obj in parse_list) {
        DataModel *dm = [[DataModel alloc] init];
        dm.event = obj[@"event"];
        //NSLog(@"obj name: %@", obj[@"name"]);
        dm.where = obj[@"where"];
        dm.pickedTime = obj[@"pickedTime"];
        dm.pickedDate = obj[@"pickedDate"];
        dm.food = obj[@"food"];
        //dm.date =obj[@"date"];
        [self.DataModelList addObject:dm];
        
    }
    
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *hourFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSString *theHour = [hourFormat stringFromDate:currentTime];
    NSString *theMinute = [minuteFormat stringFromDate:currentTime];
    NSLog(@"the hour is %@\n", theHour);
    int valueHour = [theHour intValue];
    int valueMinute = [theMinute intValue];
    int numEvents = [self.DataModelList count];
    for (int i = 0; i < numEvents; i++) {
        DataModel *dm = [[DataModel alloc] init];
        dm = _DataModelList[i];
        NSString *str = dm.pickedTime;
        str = [str substringToIndex: 2];
        NSLog(@"the picked hour is %@\n", str);
        if ([str isEqualToString: theHour])
        {
            [_nowList addObject:dm];
        }
    }

}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadModelData];
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/*
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 if (tableView == self.searchDisplayController.searchResultsTableView) {
 return self.searchResults.count;
 
 } else {
 return self.DataModelList.count;
 }
 }
 */
// Added for search
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        // Return the number of rows in the section.
    return [self.nowList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellnum"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellnum"];
    }
    
    DataModel* hi = nil;
    
        
    // Configure the cell...
    hi = [self.nowList objectAtIndex:indexPath.row];
    cell.textLabel.text = hi.event;
    cell.detailTextLabel.text = hi.where;
        
    return cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
