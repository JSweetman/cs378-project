//
//  HappeningViewController.m
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 10/21/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "HappeningViewController.h"
#import "IndivCDViewController.h"
#import <Parse/Parse.h>
#import "SimpleTableCell.h"

@interface HappeningViewController ()

@end

@implementation HappeningViewController
{
    NSArray *tableData;
    NSArray *thumbnails;
}


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
    
    // Initialize table data
    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    // Initialize thumbnails
    
    thumbnails = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"mushroom_risotto.jpg", @"full_breakfast.jpg", @"hamburger.jpg", @"ham_and_egg_sandwich.jpg", @"creme_brelee.jpg", @"white_chocolate_donut.jpg", @"starbucks_coffee.jpg", @"vegetable_curry.jpg", @"instant_noodle_with_egg.jpg", @"noodle_with_bbq_pork.jpg", @"japanese_noodle_with_pork.jpg", @"green_tea.jpg", @"thai_shrimp_cake.jpg", @"angry_birds_cake.jpg", @"ham_and_cheese_panini.jpg", nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleTableCell" bundle: [NSBundle mainBundle]]
         forCellReuseIdentifier:@"SimpleTableCell"];
    
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
    
    
    NSDate *current = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    //[[NSDate alloc] init];
    
    
    NSString *theDate = [dateFormat stringFromDate:current];
    
    NSDateFormatter *hourFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSString *theHour = [hourFormat stringFromDate:current];
    NSString *theMinute = [minuteFormat stringFromDate:current];
    NSLog(@"the hour is %@\n", theHour);
    int valueHour = [theHour intValue];
    int valueMinute = [theMinute intValue];
    int numEvents = [self.DataModelList count];
    
    
    for (int i = 0; i < numEvents; i++) {
        DataModel *dm = [[DataModel alloc] init];
        dm = _DataModelList[i];
        NSString *str = dm.pickedTime;
        NSString *eventDate = dm.pickedDate;
        str = [str substringToIndex: 2];
        NSLog(@"the picked hour is %@\n", str);
        int testedHour = [str intValue];
        //if ([str isEqualToString: theHour])
        if ([eventDate isEqualToString:theDate] && (testedHour == valueHour || testedHour == (valueHour + 1)))
        {
            [_nowList addObject:dm];
            NSLog(@"//////////////////////////////////////////");
             NSLog(@"today events outside if are %@", [[self.nowList objectAtIndex:0]event]);
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

-(NSString*) convert24To12:(NSString*) stringDate
{
    
    //NSLog(@"TIME IS %@", stringDate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:stringDate];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    return formattedDate;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    static NSString *simpleTableId = @"SimpleTableCell";
    SimpleTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableId];
    
    
    if (cell == nil) {
        cell = (SimpleTableCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableId];
    }
    
    DataModel* hi = nil;
    if (tableView == self.tableView)
    {
        NSLog(@"in forcell tableview");
        
        // Configure the cell...
        hi = [self.nowList objectAtIndex:indexPath.row];
        NSLog(@"event hi is %@", hi.event);
        cell.eventLabel.text = hi.event;
        cell.timeLabel.text = [self convert24To12:hi.pickedTime];
        NSLog(@"event is %@", cell.eventLabel.text);
        NSLog(@"tiem  is %@", cell.timeLabel.text);
        int count = 0;
        for (NSString *foodSample in tableData)
        {
            if ([[foodSample lowercaseString] containsString:[hi.food lowercaseString]])
            {
                NSLog (@"found it\n");
                NSLog(@"count is %d", count);
                cell.thumbNailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:count]];
                return cell;
            }
            count = count + 1;
        }
        //cell.textLabel.text = hi.event;
        //cell.detailTextLabel.text = hi.where;
        //cell.thumbNailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:count]];
        
    }
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    DataModel *dm = [[DataModel alloc] init];
    NSIndexPath *selectedIndex= [self.tableView indexPathForSelectedRow];    
    dm = [self.nowList objectAtIndex: selectedIndex.row];
        
    [self performSegueWithIdentifier: @"HappeningDetails" sender: self];
        
    NSLog(@"Default Display Controller");
}
    

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"HappeningDetails"]){
        NSLog(@"I'm detail\n");
        IndivCDViewController *vc = segue.destinationViewController;
        NSIndexPath *selectedIndex= [self.tableView indexPathForSelectedRow];
        
        //NSIndexPath *indexPath = (NSIndexPath *)sender;
        //NSString *date = [self.days objectAtIndex:selectedIndex.section];
        NSLog(@"//////////////////////////////////////////////////////");
        DataModel *contactToPass = [self.nowList objectAtIndex:selectedIndex.row];
        //= [self.DataModelList objectAtIndex: selectedIndex.row];
        
        //DataModel *contactToPass = [self.DataModelList objectAtIndex: indexPath.row];
        vc.hey = contactToPass;
        
        //IndivCDViewController *vc = segue.destinationViewController;
        //NSIndexPath *path = [self.tableView indexPathForCell:sender];
        //DataModel *contactToPass = self.nowList[path.row];
        //vc.hey = contactToPass;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
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
