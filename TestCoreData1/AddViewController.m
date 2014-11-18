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
    //self.time.delegate = self;
    
    self.food.delegate = self;
    
    [self.myDatePicker addTarget:self action:@selector(pkrValueChange:) forControlEvents:UIControlEventValueChanged];
    
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
    
  
    
    }
/*
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    //NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    //self.pickedTime.text = strDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    self.pickedTime.text = theTime;
    self.pickedDate.text = theDate;
    NSLog(@"time is %@\n", _pickedTime);
    NSLog(@"date is %@\n", _pickedDate);
}
*/

- (IBAction)pkrValueChange:(UIDatePicker *)sender {
    NSLog(@"I'm here\n");
    /*
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSString *dateString;
    
    dateString = [NSDateFormatter localizedStringFromDate:[picker date]
                                                dateStyle:NSDateFormatterMediumStyle
                                                timeStyle:NSDateFormatterNoStyle];
    
    [textField setText:dateString];
    */
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    NSDate *now = [sender date];
    //[[NSDate alloc] init];

    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    self.pickedTime.text = theTime;
    self.pickedDate.text = theDate;
    NSLog(@"time is %@\n", _pickedTime);
    NSLog(@"date is %@\n", _pickedDate);
    
}

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
    [newContact setValue:dm.pickedTime forKey:@"pickedTime"];
    [newContact setValue:dm.pickedTime forKey:@"pickedDate"];
    //[newContact setValue: dm.time forKey:@"time"];
    [newContact setValue: dm.food forKey:@"food"];
    NSLog(@"event is %@ \n", _event);
    NSLog(@"where is %@", _where);
    NSLog(@"food is %@", _food);
   
    NSLog(@"time is %@", _pickedTime);
    NSLog(@"date is %@", _pickedDate);
    
    PFObject *testObject = [PFObject objectWithClassName: @"FoodEvent"];
    testObject[@"event"] = dm.event;
    testObject[@"where"] = dm.where;
    testObject[@"pickedTime"]= dm.pickedTime;
    testObject[@"pickedDate"]= dm.pickedDate;

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
    //[self.pickedTime resignFirstResponder];
    
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

- (IBAction)btnSaveGo:(id)sender {
    
    _d1 = [[DataModel alloc] init];
    
    _d1.event = [self.event text];
    _d1.where = [self.where text];
    _d1.pickedTime = [self.pickedTime text];
    _d1.pickedDate = [self.pickedDate text];
    _d1.food = [self.food text];
    
    
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
    NSString *theHour = [hourFormat stringFromDate:current];
    int valueHour = [theHour intValue];
    
    NSDate *dateEventDate = [self getDateFromString:_d1.pickedDate];
    NSString *eventTime = [_d1.pickedTime substringToIndex:2];
    int testedHour = [eventTime intValue];
    
    NSComparisonResult compareDates =[dateEventDate compare:dateFromString];
    
    if ((compareDates == NSOrderedSame  && testedHour >= valueHour) || compareDates == NSOrderedDescending)
    {
        if ([_d1.event length] > 0 && [_d1.where length] > 0  && [_d1.food length] > 0){
        
        [self addNewContact:_d1];
         self.message_label.text = @"Data Saved";
        
        // Send a notification to all devices subscribed to the "Giants" channel.
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"Food"];
        [push setMessage:@"New Event added!"];
        [push sendPushInBackground];
        }
        else
        {
            self.message_label.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
            self.message_label.text = @"You must enter a value for all fields!!";
        }
        
    }
    else
    {
        self.message_label.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
        self.message_label.text = @"You must enter a date and/or time in the future";
    }
 
       
    //[NSThread sleepForTimeInterval:3.0f];
    
    //[self.navigationController popViewControllerAnimated:YES];
     
}



@end
