//
//  EventTableViewController.m
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 11/12/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "EventTableViewController.h"
#import "CDAppDelegate.h"
#import "DataModel.h"
#import "IndivCDViewController.h"
#import <Parse/Parse.h>
#import "SimpleTableCell.h"

@interface EventTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSMutableArray *DataModelList;



@end


@interface EventTableViewController() <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSArray *searchResults;
//@property (nonatomic, strong) NSMutableArray *searchResults;
@end



@implementation EventTableViewController
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.searchController= [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar  contentsController:self];
    self.searchController.delegate = self;
    self.searchController.displaysSearchBarInNavigationBar = NO;
    self.searchController.searchResultsDataSource = self;
   
    
    //Added Search
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
    
    //self.searchResults = [[NSArray alloc]init];
    self.searchResults = [[NSMutableArray alloc]init];
    [self.searchController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCell"];
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
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

-(NSString *)getStringfromDate:(NSDate *)current
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *theDate = [dateFormat stringFromDate:current];
    return theDate;
}

-(NSDate *)getDateFromString:(NSString *)theDate
{
    NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate* myDate = [myFormatter dateFromString:theDate];
    return myDate;
}

- (void)loadModelData
{
    
    NSDate *current = [NSDate date];
    //get current date as string
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"MM-dd-yyyy"];
    //NSString *theDate = [dateFormat stringFromDate:current];
    
    NSString *theDate = [self getStringfromDate:current];
    NSLog(@"the date is %@", theDate);
    //convert date string back to NSDATE
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    //NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    //dateFromString = [dateFormatter dateFromString:theDate];
    NSDate *dateFromString = [self getDateFromString:theDate];
    
    NSDateFormatter *hourFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSString *theHour = [hourFormat stringFromDate:current];
    //NSString *theMinute = [minuteFormat stringFromDate:current];
    NSLog(@"the hour is %@\n", theHour);
    int valueHour = [theHour intValue];
    //int valueMinute = [theMinute intValue];
    
    self.DataModelList = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    
    [query addAscendingOrder:@"pickedDate"];
    [query addAscendingOrder:@"pickedTime"];
    //[query orderByAscending:@"pickedTime"];
    NSArray *parse_list = [query findObjects];
    
    for (PFObject *obj in parse_list) {
        NSLog(@"object name in Parse: %@", obj[@"event"]);
    }
    
    for (PFObject *obj in parse_list) {
        NSString *eventTime = obj[@"pickedTime"];
        NSString *eventDate = obj[@"pickedDate"];
        NSDate *dateEventDate = [dateFormatter dateFromString:eventDate];
        eventTime = [eventTime substringToIndex:2];
        int testedHour = [eventTime intValue];
        NSComparisonResult compareDates =[dateEventDate compare:dateFromString];
        if ((compareDates == NSOrderedSame  && testedHour >= valueHour)|| compareDates == NSOrderedDescending){
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
        
    }
    for (DataModel *dm in self.DataModelList) {
        NSLog(@"object name for loop name: %@", dm.event);
    }
    /*
     CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
     NSManagedObjectContext *context = appDelegate.managedObjectContext;
     NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
     NSFetchRequest *request = [[NSFetchRequest alloc] init];
     [request setEntity:entityDescription];
     
     // LOOK
     //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name = %@)", _d1.name];    [request setPredicate:predicate];
     
     // Fetch (read) the data
     NSError *error;
     NSArray *objects = [context executeFetchRequest:request error:&error];
     self.DataModelList = [NSMutableArray new];
     
     if ([objects count] == 0) {
     NSLog(@"No Matches");
     } else {
     NSManagedObject *item = nil;
     //LOOK
     for (int i = 0; i < [objects count]; i++) {
     item = objects[i];
     DataModel *dm = [[DataModel alloc] init];
     dm.event = [item valueForKey:@"event"];
     dm.where = [item valueForKey:@"where"];
     dm.time =[item valueForKey:@"time"];
     dm.food =[item valueForKey:@"food"];
     [self.DataModelList addObject: dm];
     }
     }
     
     */
    
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    DataModel *dm = [[DataModel alloc] init];
    
    //if (tableView == self.searchDisplayController.searchResultsTableView) {
      if (tableView == self.searchController.searchResultsTableView) {
        dm = [self.searchResults objectAtIndex: self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
        
        [self performSegueWithIdentifier: @"Details" sender:self];
        
        NSLog(@"Search Display Controller");
    }
    
    else {
        
        dm = [self.DataModelList objectAtIndex: indexPath.row];
        
        [self performSegueWithIdentifier: @"Details" sender: self];
        
        NSLog(@"Default Display Controller");
    }
    
}

//LOOK need to go to AddViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Details"]){
         NSLog(@"I'm detail\n");
        IndivCDViewController *vc = segue.destinationViewController;
        //NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        //DataModel *contactToPass = self.DataModelList[path.row];
        //vc.hey = contactToPass;
        
        if (self.searchController.active) {
            NSLog(@"Search Display Controller1");
            DataModel *contactToPass = [self.searchResults objectAtIndex: self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
            //DataModel *contactToPass = self.searchResults[path.row];
            vc.hey = contactToPass;
            
        } else {
            NSLog(@"Default Display Controller1");
            DataModel *contactToPass = [self.DataModelList objectAtIndex: self.tableView.indexPathForSelectedRow.row];
            vc.hey = contactToPass;
        }
        /*
        if (sender != self.tableView)
        {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            DataModel *contactToPass = self.DataModelList[path.row];
            vc.hey = contactToPass;
        }
        else
        {
        
            NSIndexPath *path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            DataModel *contactToPass = self.searchResults[path.row];
            vc.hey = contactToPass;
        }
         */
    }
    
}


//Added for search1

-(void)filterResults:(NSString *)searchTerm {
    
    NSLog(@"Here");
    NSMutableArray *newResults = [NSMutableArray new];
    for (DataModel *event in self.DataModelList)
    {
        if ([[event.event lowercaseString] containsString:[searchTerm lowercaseString]] || [[event.food lowercaseString] containsString:[searchTerm lowercaseString]] || [[event.where lowercaseString]containsString:[searchTerm lowercaseString]] || [[event.pickedTime lowercaseString] containsString:[searchTerm lowercaseString]] || [[event.pickedDate lowercaseString] containsString:[searchTerm lowercaseString]])
        {
            [newResults addObject:event];
        }
    }
    
    //NSString *predicateText = @"event";
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"event CONTAINS[c] %@", searchTerm];
    
    //PFQuery *query = [PFQuery queryWithClassName: @"FoodEvent" predicate: resultPredicate];
    
    //self.searchResults = (NSMutableArray*)[self.DataModelList filteredArrayUsingPredicate:resultPredicate];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    //[query whereKeyExists:@"event"];
    //[query whereKeyExists:@"where"];
    //[query whereKeyExists:@"time"];
    //[query whereKeyExists:@"food"];
//    [query whereKey:@"event" containsString:searchTerm];
    //[query whereKey:@"where" containsString:searchTerm];
    //[query whereKey:@"time" containsString:searchTerm];
    //[query whereKey:@"food" containsString:searchTerm];
    
    //[query findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    
//    NSArray *results  = [query findObjects];
    
    NSLog(@"The results are : %@", newResults);
    NSLog(@"The count is %u", newResults.count);
    
    //This is breaking it.
    
    self.searchResults = newResults;
     
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}
//Added for search2
/*
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
 */
 

//Search1
- (void)callbackWithResult:(NSArray *)foundit error:(NSError *)error
{
    if(!error) {
//        [self.searchResults removeAllObjects];
//        [self.searchResults addObjectsFromArray:foundit];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}



// UiTableViewController data source and delegate methods

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
  
    //Added for search
    if (tableView == self.tableView) {
        //if (tableView == self.searchDisplayController.searchResultsTableView) {
        //NSLog(@"Prase Count: %ld", (unsigned long)[self.objects count]);
        return [self.DataModelList count];
        
    } else {
        NSLog(@"Search Count: %ld", (unsigned long)[self.searchResults count]);
        return self.searchResults.count;
    }
   
    // Return the number of rows in the section.
    return [self.DataModelList count];
}

//NO
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    // Configure the cell...
    DataModel* hi = [self.DataModelList objectAtIndex:indexPath.row];
    cell.textLabel.text = hi.event;
    cell.detailTextLabel.text = hi.where;
    
    return cell;
    
    
    
    
}
*/
//Search2
/*
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //[self.searchResults removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"event contains[c] %@", searchText];
    self.searchResults = [self.DataModelList filteredArrayUsingPredicate:resultPredicate];
}
 */

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //UITableViewCell
    
    static NSString *simpleTableId = @"SimpleTableCell";
    SimpleTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableId];
    /*
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    
    //DataModel *dm = nil;
    DataModel* hi = nil;
    
    
     
    // Display recipe in the table cell
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        hi = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = hi.event;
        cell.detailTextLabel.text = hi.where;
    }
    else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellid"];
        hi = [self.DataModelList objectAtIndex:indexPath.row];
        cell.textLabel.text = hi.event;
        cell.detailTextLabel.text = hi.where;
    }
    
    return cell;
   */
    
    
    //Search1
    
    if (cell == nil) {
         cell = (SimpleTableCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableId];
     }
    
    DataModel* hi = nil;
    if (tableView == self.tableView) {
        NSLog(@"in forcell tableview");
        SimpleTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableId];
        
        // Configure the cell...
        hi = [self.DataModelList objectAtIndex:indexPath.row];
        NSLog(@"event hi is %@", hi.event);
        cell.eventLabel.text = hi.event;
        cell.timeLabel.text = hi.pickedTime;
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
        return cell;
    }
    else {
        //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
        SimpleTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableId];
        hi = [self.searchResults objectAtIndex:indexPath.row];
        //cell.textLabel.text = hi.event;
        //cell.detailTextLabel.text = hi.where;
        cell.eventLabel.text = hi.event;
        cell.timeLabel.text = hi.pickedTime;
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
        
        return cell;
    }
 
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}
*/
    
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
// 
//    }
//    if ([_searchResults count] == 0) {
//            //cell.mainTitle.text = @"Nothing Found";
//        return 0;
//    } 
//    else {
//        PFObject *object = [PFObject objectWithClassName:@"FoodEvent"];
//        object = [_searchResults objectAtIndex:indexPath.row];
//            //DataModel* obj = [_searchResults objectAtIndex:indexPath.row];
//        //cell.textLabel.text = object.event;
//        //cell.detailTextLabel.text = object.where;
//            
//    }
    
    
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end






















