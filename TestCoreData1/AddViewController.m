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
    NSArray* pickerDataFood;
    NSArray* pickerDataWhere;
    NSArray* pickerAddress;
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
    
    //Picker
    // Initialize Data
    pickerDataFood = @[@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini"];
    pickerDataWhere = @[@"GDC", @"Test"];
    pickerAddress = @[@"2317 Speedway, Austin, TX 78712", @"950 West 5th St, Austin, TX 78703"];
    
    
    // Connect data
    
    self.pickerFood = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerWhere = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    [self attachPickerToTextField:self.food :self.pickerFood];
    [self attachPickerToTextField:self.where :self.pickerWhere];
    
    
    //self.pickerFood.hidden = YES;
    //self.picker.dataSource = self;
    //elf.picker.delegate = self;
    
    ////////////////////////
    
    self.event.delegate = self;
    //self.where.delegate = self;
    //self.food.delegate = self;
    
    [self.myDatePicker addTarget:self action:@selector(pkrValueChange:) forControlEvents:UIControlEventValueChanged];
    
    // Register for keyboard notifications.
    //
    // Register for when the keyboard is shown.
    // To make sure the text field that has focus can be seen by the user.
    //if (self == self.event.delegate)
    //{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    //}
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

- (void)attachPickerToTextField: (UITextField*) textField :(UIPickerView*) picker{
    picker.delegate = self;
    picker.dataSource = self;
    
    textField.delegate = self;
    textField.inputView = picker;
    
    // Create done button in UIPickerView
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [mypickerToolbar setItems:barItems animated:YES];
    
    
    //self.pickerFood.showsSelectionIndicator = YES;
    textField.inputAccessoryView = mypickerToolbar;
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
    
    NSDate* now = [sender date];
    //[[NSDate alloc] init];
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"hh:mm a"];
    //NSString *str_date = [dateFormatter stringFromDate:[NSDate date]];
    
    
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
///////////////////////////////////////////////////////////////////////

- (IBAction)whenButtonTapped:(id)sender
{
    
    [self attachPickerToTextField:self.food :self.pickerFood];
    /*
    if(self.pickerFood.hidden) //it is appearing
    {
        self.pickerFood.hidden = NO;
    }
    else
    {
        self.pickerFood.hidden = YES;
    }\*/
    
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.pickerFood){
        return pickerDataFood.count;
    }
    else if (pickerView == self.pickerWhere){
        return pickerDataWhere.count;
    }
    
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView == self.pickerFood){
        return [pickerDataFood objectAtIndex:row];
    }
    else if (pickerView == self.pickerWhere){
        return [pickerDataWhere objectAtIndex:row];
    }
    
    return @"???";
    //return pickerDataFood[row];
    //return [self.pickerData objectAtIndex:row];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    if (pickerView == self.pickerFood){
        thisLabel.text = [pickerDataFood objectAtIndex:row];
    }
    else if (pickerView == self.pickerWhere){
        thisLabel.text = [pickerDataWhere objectAtIndex:row];
    }
    
    
    return thisLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == self.pickerFood){
        self.food.text = [pickerDataFood objectAtIndex:row];
    }
    else if (pickerView == self.pickerWhere){
        self.where.text = [pickerDataWhere objectAtIndex:row];
    }
    
    //int chosen = [pickerView selectedRowInComponent:component];
    //NSLog(@"you choose %@", [pickerDataFood objectAtIndex:chosen]);
}


#pragma mark - Picker delegate stuff


/////////////////////////////////////////////////////////////////////////////////


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
    [self.food resignFirstResponder];
    //[self.pickerFood resignFirstResponder];
    //[self.pickedTime resignFirstResponder];
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

- (void) pickerDoneClicked{
    //[self.where resignFirstResponder];
    if (self.pickerFood){
        [self.food resignFirstResponder];
    }
    if (self.pickerWhere){
        [self.where resignFirstResponder];
    }
    /*
    [UIView animateWithDuration:0.3 animations:^{
        // Restore the parent view and scroll content view to their original sizes
        self.view.frame = originalViewFrame;
        self.scrollView.contentSize = originalViewFrame.size;
    }];
     */
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
    int count = 0;
    for (NSString *address in pickerDataWhere)
    {
        if ([[self.where text] isEqualToString:address])
        {
            _d1.where = [pickerAddress objectAtIndex:count];
        }
        count = count + 1;
    }
    _d1.event = [self.event text];
    //_d1.where = [self.where text];
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
        [self performSegueWithIdentifier:@"main" sender:self];
        /////////////////////
        /*
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"Food"];
        [push setMessage:@"New Event added!"];
        [push sendPushInBackground];
        */
        
        
        NSString *newString = [self.food.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        /*
        PFQuery *innerQuery = [PFUser query];
            
            // Use hasPrefix: to only match against the month/date
            [innerQuery whereKey:@"birthday" hasPrefix:@"08/15"];
            
            // Build the actual push notification target query
            PFQuery *query = [PFInstallation query];
            
            // only return Installations that belong to a User that
            // matches the innerQuery
            [query whereKey:@"user" matchesQuery:innerQuery];
         */   
            
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:newString];
        NSString* message = [NSString stringWithFormat:@"New %@ event added!", self.food.text];
        [push setMessage:message];
        [push sendPushInBackground];
          
          
        //PFQuery *pushQuery = [PFInstallation query];
        //[pushQuery whereKey:@"user" matchesQuery:userQuery];
        /*
        PFQuery *innerQuery = [PFUser query];
            
            // Use hasPrefix: to only match against the month/date
        [innerQuery whereKey:@"channels" equalTo:newString];
            
            // Build the actual push notification target query
        PFQuery *query = [PFInstallation query];
            
            // only return Installations that belong to a User that
            // matches the innerQuery
        [query whereKey:@"user" matchesQuery:innerQuery];
            
            // Send the notification.
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:query];
        NSString* message = [NSString stringWithFormat:@"New %@ event added!", self.food.text];
        [push setMessage:message];
        [push sendPushInBackground];
       
            //PFQuery *pushQuery = [PFInstallation query];
            //[pushQuery whereKey:@"user" matchesQuery:userQuery];
            
            // Send push notification to query
            //PFPush *push = [[PFPush alloc] init];
            //[push setQuery:pushQuery]; // Set our Installation query
        */
        
            
        }
        else
        {
           
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You must enter a value for all fields!!" delegate:nil cancelButtonTitle:@"Hide" otherButtonTitles:nil];
            //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            
            //self.message_label.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
            //self.message_label.text = @"You must enter a value for all fields!!";
        }
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You must enter a date and/or time in the future" delegate:nil cancelButtonTitle:@"Hide" otherButtonTitles:nil];
        //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        //self.message_label.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
        //self.message_label.text = @"You must enter a date and/or time in the future";
    }
 
       
    //[NSThread sleepForTimeInterval:3.0f];
    
    //[self.navigationController popViewControllerAnimated:YES];
     
}

@end
