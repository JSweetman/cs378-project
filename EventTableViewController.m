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


//@interface EventTableViewController ()
//@property (weak, nonatomic) IBOutlet UITableView* tableView;
//@property (strong, nonatomic) NSMutableArray *DataModelList;



//@end


@interface EventTableViewController() <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, strong) NSMutableDictionary *groupedEvents;

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
    //[self.tableView reloadData];
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
    
    NSString *theDate = [self getStringfromDate:current];
    NSLog(@"the date is %@", theDate);
    //convert date string back to NSDATE
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
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
    [self groupEventsIntoDays];
    for (DataModel *dm in self.DataModelList) {
        NSLog(@"object name for loop name: %@", dm.event);
    }
    
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    DataModel *dm = [[DataModel alloc] init];
    //NSInteger rowIndex = indexPath.section+indexPath.row;
    //NSIndexPath *selectedIndex= [self.tableView indexPathForSelectedRow];
    //if (tableView == self.searchDisplayController.searchResultsTableView) {
    
    if (tableView == self.searchController.searchResultsTableView) {
        NSIndexPath *selectedIndex= [self.searchController.searchResultsTableView indexPathForSelectedRow];
        NSLog(@" indexPath row in didSelect %d", selectedIndex.row);
        NSLog(@" indexPath section %d",selectedIndex.section);
          //NSString *date = [self.days objectAtIndex:selectedIndex.section];
          //dm = [((NSMutableArray*)[self.groupedEvents objectForKey:date]) objectAtIndex:selectedIndex.row];
        dm = [self.searchResults objectAtIndex: selectedIndex.row];
        //dm = [self.searchResults objectAtIndex: self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
        
        [self performSegueWithIdentifier: @"Details" sender:self];
        
        NSLog(@"Search Display Controller");
    }
    
    else {
        NSIndexPath *selectedIndex= [self.tableView indexPathForSelectedRow];
        NSLog(@"//////////////////////////////////////////////////////");
        NSLog(@" indexPath row %d", selectedIndex.row);
        NSLog(@" indexPath section %d",selectedIndex.section);
        //dm = [self.DataModelList objectAtIndex: indexPath.row];
        NSString *date = [self.days objectAtIndex:indexPath.section];
        [((NSMutableArray*)[self.groupedEvents objectForKey:date]) objectAtIndex:selectedIndex.row];
        [self performSegueWithIdentifier: @"Details" sender: self];
        
        NSLog(@"Default Display Controller");
    }
   
    
}

//LOOK need to go to AddViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Details"]){
         NSLog(@"I'm detail\n");
        IndivCDViewController *vc = segue.destinationViewController;
        //[[globalArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
        if (self.searchController.active) {
            NSLog(@"Search Display Controller1");
         
            NSIndexPath *selectedIndex= [self.searchController.searchResultsTableView indexPathForSelectedRow];
            NSLog(@" indexPath row %d", selectedIndex.row);
            NSLog(@" indexPath section %d",selectedIndex.section);
            DataModel *contactToPass = [self.searchResults objectAtIndex: selectedIndex.row];
            
            //NSIndexPath *selectedIndex= [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            //NSString *date = [self.days objectAtIndex:selectedIndex.section];
            //DataModel *contactToPass = [((NSMutableArray*)[self.groupedEvents objectForKey:date]) objectAtIndex:selectedIndex.row];
            vc.hey = contactToPass;
        //objectAtIndex: [self.tableView indexPathForSelectedRow].section]
        } else {
            NSLog(@"Default Display Controller1");
            
            NSIndexPath *selectedIndex= [self.tableView indexPathForSelectedRow];
            
            //NSIndexPath *indexPath = (NSIndexPath *)sender;
            NSString *date = [self.days objectAtIndex:selectedIndex.section];
            NSLog(@"//////////////////////////////////////////////////////");
            DataModel *contactToPass = [((NSMutableArray*)[self.groupedEvents objectForKey:date]) objectAtIndex:selectedIndex.row];
             //= [self.DataModelList objectAtIndex: selectedIndex.row];
            
            //DataModel *contactToPass = [self.DataModelList objectAtIndex: indexPath.row];
            vc.hey = contactToPass;
        }
        
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
    
    
    NSLog(@"The results are : %@", newResults);
    NSLog(@"The count is %u", newResults.count);
    
    
    self.searchResults = newResults;
     
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self.searchDisplayController.searchResultsTableView reloadData];
    [self filterResults:searchString];
    return YES;
}


//Search1
- (void)callbackWithResult:(NSArray *)foundit error:(NSError *)error
{
    if(!error) {
//        [self.searchResults removeAllObjects];
//        [self.searchResults addObjectsFromArray:foundit];
//        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}



// UiTableViewController data source and delegate methods
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
*/


- (void)groupEventsIntoDays
{
    self.days = [NSMutableArray new];
    self.groupedEvents = [NSMutableDictionary new];
    for (DataModel *event in self.DataModelList)
    {
        
        if (![self.days containsObject:event.pickedDate])
        {
            NSLog(@"I'm in group");
            NSLog(@"object is %@", event.pickedDate);
            [self.days addObject: event.pickedDate];
            NSLog(@"days object is %@", self.days[0]);
            [self.groupedEvents setObject:[NSMutableArray arrayWithObject:event] forKey:event.pickedDate];
        }
        else
        {
            [((NSMutableArray*)[self.groupedEvents objectForKey:event.pickedDate]) addObject:event];
        }
    }
    
    //self.days = [[self.days sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"days count is %d\n", [self.days count]);
    if (tableView == self.tableView){
        return [self.days count];
    }
    else
    {
        return 1;
    }
        
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    //Added for search
    if (tableView == self.tableView) {
        
        NSString *sectionTitle = [self.days objectAtIndex:section];
        NSArray *sectionDate = [self.groupedEvents objectForKey: sectionTitle];
        return [sectionDate count];
        //return [self.DataModelList count];
        
    } else {
        NSLog(@"Search Count: %ld", (unsigned long)[self.searchResults count]);
        NSLog(@"number of search rows %d", self.searchResults.count);
        return self.searchResults.count;
    }
    
    // Return the number of rows in the section.
    return [self.DataModelList count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //if (tableView == self.searchDisplayController.searchResultsTableView){
        
     //   return nil;
        
    //}
    // create the parent view that will hold header Label
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
    
    UIImage *image = [UIImage imageNamed:@"Background_320x22"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    // create the button object
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.backgroundColor = [UIColor orangeColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.highlightedTextColor = [UIColor blueColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.frame = CGRectMake(0.0, 0.0, 320.0, 22.0);
    NSString *dateAsString = [self.days objectAtIndex:section];
    if (tableView == self.tableView)
    {
        [headerLabel setText:dateAsString];    //headerLabel.text = @"My Header"; // i.e. array element
    }
    else
    {
       [headerLabel setText: @"Search Results"];
    }
    [customView addSubview:imageView];
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSLog(@"section title is %@",[self.days objectAtIndex:section] );
    return [self.days objectAtIndex:section];
}

-(NSString*) convert24To12:(NSString*) stringDate
{
    
    //NSLog(@"TIME IS %@", stringDate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:stringDate];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    if ([[formattedDate substringToIndex:1] isEqualToString: @"0"])
    {
        formattedDate = [formattedDate substringFromIndex:1];
    }
    
    return formattedDate;

}

-(NSString*)grabStreetAddress:(NSString*) address
{
    NSArray *subStrings = [address componentsSeparatedByString:@","];
    for (int i = 0; i < [subStrings count]; i++)
    {
        NSLog(@"string on array position %d is : %@", i, [subStrings objectAtIndex:i]);
    }
    return [subStrings objectAtIndex:0];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //UITableViewCell
    //NSArray *sectionDate = [groupedEvents objectForKey:sectionTitle];
    NSString *date = [self.days objectAtIndex:indexPath.section];
    DataModel *event;
    //NSLog(@"in cell date is %@", date);
    
    //DataModel *event = [self.groupedEvents objectForKey: date];
    
    //NSLog(@"Event is %@\n", event.event);
    static NSString *simpleTableId = @"SimpleTableCell";
    SimpleTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableId];
    
    
    //Search1
    
    if (cell == nil) {
         cell = (SimpleTableCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableId];
     }
    
    //DataModel* hi = nil;
    if (tableView == self.tableView) {
        NSLog(@"in forcell tableview");
        //SimpleTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableId];
        
        // Configure the cell...
        //hi = [self.DataModelList objectAtIndex:indexPath.row];
        //NSLog(@"event hi is %@", hi.event);
        //cell.eventLabel.text = hi.event;
        //cell.timeLabel.text = hi.pickedTime;
        
        
        //NSLog(@"event is %@", cell.eventLabel.text);
        //NSLog(@"tiem  is %@", cell.timeLabel.text);
        event = [((NSMutableArray*)[self.groupedEvents objectForKey:date]) objectAtIndex:indexPath.row];
        
        cell.eventLabel.text = event.event;
        cell.timeLabel.text = [self convert24To12:event.pickedTime];
        //cell.whereLabel.text = event.where;
        cell.whereLabel.text = [self grabStreetAddress:event.where];
        
        NSLog(@"//////////////////////////////////////////////////////");
        int count = 0;
        for (NSString *foodSample in tableData)
        {
            if ([[foodSample lowercaseString] containsString:[event.food lowercaseString]])
            {
                NSLog (@"found it\n");
                NSLog(@"count is %d", count);
                cell.thumbNailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:count]];
                NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
                NSLog(@" indexPath row for LIST %@ in cell is %d", event.event, indexPath.row);
                NSLog(@" indexPath section for LIST %@ in cell is  %d",event.event, indexPath.section);
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
        
        //[self.searchDisplayController.searchResultsTableView reloadData];
        //SimpleTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableId];
        event = [self.searchResults objectAtIndex:indexPath.row];
        //cell.textLabel.text = hi.event;
        //cell.detailTextLabel.text = hi.where;
        
        //NSLog(@"index path for %@ is %d", event.event, indexPath.row);
        
        NSLog(@"//////////////////////////////////////////////////////");
        cell.eventLabel.text = event.event;
        cell.whereLabel.text = event.event;
        cell.timeLabel.text = [self convert24To12:event.pickedTime];
        int count = 0;
        for (NSString *foodSample in tableData)
        {
            if ([[foodSample lowercaseString] containsString:[event.food lowercaseString]])
            {
                NSLog (@"found it\n");
                NSLog(@"count is %d", count);
                cell.thumbNailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:count]];
                NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
                NSLog(@" indexPath row for event %@ in cell is %d", event.event, indexPath.row);
                NSLog(@" indexPath section in cell %@ in cell is  %d",event.event, indexPath.section);
                return cell;
            }
            count = count + 1;
        }
        
        return cell;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


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
    
    
    
//}


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






















