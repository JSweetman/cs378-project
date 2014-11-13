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

@interface EventTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *DataModelList;

@end


@interface EventTableViewController() <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end



@implementation EventTableViewController

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

- (void)loadModelData
{
    
    self.DataModelList = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    NSArray *parse_list = [query findObjects];
    for (PFObject *obj in parse_list) {
        DataModel *dm = [[DataModel alloc] init];
        dm.event = obj[@"event"];
        //NSLog(@"obj name: %@", obj[@"name"]);
        dm.where = obj[@"where"];
        dm.time = obj[@"time"];
        dm.food = obj[@"food"];
        [self.DataModelList addObject:dm];
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


//LOOK need to go to AddViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Details"]){
        IndivCDViewController *vc = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        DataModel *contactToPass = self.DataModelList[path.row];
        vc.hey = contactToPass;
    }
    
}

//Added for search
-(void)filterResults:(NSString *)searchTerm {
    
    [self.searchResults removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName: @"FoodEvent"];
    [query whereKeyExists:@"event"];  //this is based on whatever query you are trying to accomplish
    [query whereKeyExists:@"where"]; //this is based on whatever query you are trying to accomplish
    [query whereKeyExists:@"time"];  //this is based on whatever query you are trying to accomplish
    [query whereKeyExists:@"food"];
    [query whereKey:@"event" containsString:searchTerm];
    [query whereKey:@"where" containsString:searchTerm];
    [query whereKey:@"time" containsString:searchTerm];
    [query whereKey:@"food" containsString:searchTerm];
    
    [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    
    //NSArray *results  = [query findObjects];
    
    //NSLog(@"%@", results);
    //NSLog(@"%u", results.count);
    
    //[self.searchResults addObjectsFromArray:results];
}

//Added for search
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];
    return YES;
}

- (void)callbackWithResult:(NSArray *)celebrities error:(NSError *)error
{
    if(!error) {
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:celebrities];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}



// UiTableViewController data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// Added for search
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    
    //Added for search
    if (tableView == self.tableView) {
        //if (tableView == self.searchDisplayController.searchResultsTableView) {
        //NSLog(@"Prase Count: %ld", [self.objects count]);
        return self.objects.count;
        
    } else {
        //NSLog(@"Search Count: %ld", [self.searchResults count]);
        return self.searchResults.count;
        
        
    }
   
    // Return the number of rows in the section.
    return [self.DataModelList count];
}
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



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
 
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
        
        // Configure the cell...
        DataModel* hi = [self.DataModelList objectAtIndex:indexPath.row];
        cell.textLabel.text = hi.event;
        cell.detailTextLabel.text = hi.where;
        
        return cell;
    }
    else {
        UITableViewCell *cell = [self.searchController.searchResultsTableView dequeueReusableCellWithIdentifier:@"searchCell"];
        cell.textLabel.text = @"Hi";
        cell.detailTextLabel.text = @"Hello";
        
        return cell;
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






















