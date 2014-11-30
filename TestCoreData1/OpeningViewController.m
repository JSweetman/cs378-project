//
//  OpeningViewController.m
//  Project
//
//  Created by Christopher Metcalf on 10/16/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "OpeningViewController.h"
#import "HappeningViewController.h"
#import <Parse/Parse.h>


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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickButtonAdd:(id)sender {
    if (![PFUser currentUser])
    {
        [self performSegueWithIdentifier: @"SignIn" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier: @"AddEvent" sender:self];
    }
        
}
@end
