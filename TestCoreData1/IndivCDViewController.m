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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.event.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.where.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.time.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.food.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    self.event.text = self.hey.event;
    self.where.text = self.hey.where;
    self.time.text =self.hey.time;
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
