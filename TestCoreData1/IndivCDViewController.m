//
//  IndivCDViewController.m
//  TestCoreData1
//
//  Created by CHRISTOPHER METCALF on 10/7/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "IndivCDViewController.h"

@interface IndivCDViewController ()

@end

@implementation IndivCDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(NSString*)grabStreetAddress:(NSString*) address
{
    NSArray *subStrings = [address componentsSeparatedByString:@","];
    for (int i = 0; i < [subStrings count]; i++)
    {
        NSLog(@"string on array position %d is : %@", i, [subStrings objectAtIndex:i]);
    }
    return [subStrings objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.event.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.where.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.pickedTime.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.pickedDate.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.food.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.event.text = self.hey.event;
    self.where.text = [self grabStreetAddress:self.hey.where];
    self.pickedTime.text = [self convert24To12:self.hey.pickedTime];
    self.pickedDate.text = self.hey.pickedDate;
    self.food.text = self.hey.food;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
