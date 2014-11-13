//
//  AddViewController.m
//  TestCoreData1
//
//  Created by CHRISTOPHER METCALF on 10/4/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "AddViewController.h"
#import "DataModel.h"
#import "CDViewController.h"
#import "CDAppDelegate.h"
#import <Parse/Parse.h>
//#import "CoreGraphics/CGGeometry.h"

@interface AddViewController ()
@property(strong, nonatomic) DataModel *d1;

@end

@implementation AddViewController
{
    CGRect originalViewFrame;
    UITextField *textFieldWithFocus;
}


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
    self.event.delegate = self;
    self.where.delegate = self;
    self.time.delegate = self;
    self.food.delegate = self;
    
    // Register for keyboard notifications.
    //
    // Register for when the keyboard is shown.
    // To make sure the text field that has focus can be seen by the user.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    // Register for when the keyboard is hidden.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
    
    
    // Remember the starting frame for the view
    originalViewFrame = self.view.frame;
    
    // Set the scroll view to the same size as its parent view - typical
    self.scrollView.frame = originalViewFrame;
    
    // Set the content size to the same size as the scroll view - for now.
    // Later we'll be changing the content size to allow for scrolling.
    // Right now, no scrolling would occur because the content and the scroll view
    // are the same size.
    self.scrollView.contentSize = originalViewFrame.size;
    
  
    
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //testObject[@"foo"] = @"bar";
    //[testObject saveInBackground];
    
    
    // Do any additional setup after loading the view.
    /*
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    self.scrollView.contentSize = scrollContentSize;
    */
}

/*
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

*/


-(void)modifiedData:(NSString*)data
{
    
    //GCD
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        // Update Text
        
        self.message_label.text = data;
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void) addNewContact:(DataModel*) dm
{
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    [newContact setValue: dm.event forKey:@"event"];
    [newContact setValue: dm.where forKey:@"where"];
    [newContact setValue: dm.time forKey:@"time"];
    [newContact setValue: dm.food forKey:@"food"];
    
    PFObject *testObject = [PFObject objectWithClassName: @"FoodEvent"];
    testObject[@"event"] = dm.event;
    testObject[@"where"] = dm.where;
    testObject[@"time"]= dm.time;
    testObject[@"food"] = dm.food;
    [testObject saveInBackground];
    
    
    // Save changes to the persistent store
    NSError *error;
    [context save:&error];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    // Indicate we're done with the keyboard. Make it go away.
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.event resignFirstResponder];
    [self.where resignFirstResponder];
    [self.time resignFirstResponder];
    [self.food resignFirstResponder];
}


// Called when the keyboard will be shown.
- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    int adjust = 0;
    int pad = 5;
    
    int top = originalViewFrame.size.height - keyboardFrame.size.height - pad - textFieldWithFocus.frame.size.height;
    
    if (textFieldWithFocus.frame.origin.y > top) {
        adjust = textFieldWithFocus.frame.origin.y - top;
    }
    
    CGRect newViewFrame = originalViewFrame;
    newViewFrame.origin.y -= adjust;
    newViewFrame.size.height = originalViewFrame.size.height + keyboardFrame.size.height;
    
    // Change the content size so we can scroll up and expose the text field widgets
    // currently under the keyboard.
    CGSize newContentSize = originalViewFrame.size;
    newContentSize.height += (keyboardFrame.size.height * 2);
    self.scrollView.contentSize = newContentSize;
        
    // Move the view to keep the text field from being covered up by the keyboard.
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = newViewFrame;
    }];
}

// Called when the keyboard will be hidden - the user has touched the Return key.
- (void) keyboardDidHide:(NSNotification *)note {
    
    [UIView animateWithDuration:0.3 animations:^{
        // Restore the parent view and scroll content view to their original sizes
        self.view.frame = originalViewFrame;
        self.scrollView.contentSize = originalViewFrame.size;
    }];
}

// Called when you touch inside a text field.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // Remember which text field has focus
    textFieldWithFocus = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textFieldWithFocus = nil;
}




- (IBAction)btnSaveGo:(id)sender {
    
    _d1 = [[DataModel alloc] init];
    //_d1.delegate = (id)self;
    
    //self.name.delegate = self;
    //self.city.delegate = self;
    //self.state.delegate = self;
    //self.phone.delegate = self;
    
    _d1.event = [self.event text];
    _d1.where = [self.where text];
    _d1.time = [self.time text];
    _d1.food = [self.food text];
    
    if ([_d1.event length] > 0 && [_d1.where length] > 0 && [_d1.time length] > 0  && [_d1.food length] > 0){
        
        [self addNewContact:_d1];
         self.message_label.text = @"Data Saved";
        
        // Send a notification to all devices subscribed to the "Giants" channel.
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"Food"];
        [push setMessage:@"New Event added!"];
        [push sendPushInBackground];
        
  /*
        Parse.Push.send({
        channels: [ "Giants", "Mets" ],
        data: {
        alert: "The Giants won against the Mets 2-3."
        }
        }, {
        success: function() {
            // Push was successful
        },
        error: function(error) {
            // Handle error
        }
        });
    */
        
    }
 
    else
    {
        self.message_label.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
        self.message_label.text = @"You must enter a value for all fields!!";
    }
   
    //[NSThread sleepForTimeInterval:3.0f];
    
    //[self.navigationController popViewControllerAnimated:YES];
     
}


@end
