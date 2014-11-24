//
//  OpeningViewController.m
//  Project
//
//  Created by Christopher Metcalf on 10/16/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "OpeningViewController.h"
#import "HappeningViewController.h"


@interface OpeningViewController ()

@end

@implementation OpeningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"Happening"]){
        NSLog(@"I'm happening\n");
        HappeningViewController *vc = segue.destinationViewController;
        //NSIndexPath *path = [self.tableView indexPathForCell:sender];
      
         NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
         NSDateComponents *components = [gregorian components: (NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate: self];
         NSInteger hour = [components hour];
         NSInteger minute = [components minute];
 
        
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
                [vc.nowList addObject:dm];
            }
            
            
        }
    }
}
*/
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
