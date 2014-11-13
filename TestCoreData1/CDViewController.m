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
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //testObject[@"foo"] = @"bar";
    //[testObject saveInBackground];    // create d1 object
    
    // When users indicate they are Giants fans, we subscribe them to that channel.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"Food" forKey:@"channels"];
    [currentInstallation saveInBackground];
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
