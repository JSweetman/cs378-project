//
//  NewUserViewController.m
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 11/18/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "NewUserViewController.h"
#import "ActivityView.h"
#import <Parse/Parse.h>

@interface NewUserViewController () <UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *createAccountButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

@property (nonatomic, assign) CGFloat iconImageViewOriginalY;
@property (nonatomic, assign) CGFloat iconLogoOffsetY;

@end

@implementation NewUserViewController
{
    CGRect originalViewFrame;
    UITextField *textFieldWithFocus;
    NSArray* pickerDataFood;
}

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        ////////self.automaticallyAdjustsScrollViewInsets = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //[self.scrollView setScrollEnabled:YES];
    pickerDataFood = @[@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini"];
    
    self.pickerFood = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self attachPickerToTextField:self.food :self.pickerFood];
    
    // For dismissing keyboard
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self registerForKeyboardNotifications];
    
    // Save original y position and offsets for floating views
    self.iconImageViewOriginalY = self.iconImageView.frame.origin.y;
    self.iconLogoOffsetY = self.logoImageView.frame.origin.y - self.iconImageView.frame.origin.y;
  
    ////////
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
///////////////////
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
    
    
    self.pickerFood.showsSelectionIndicator = YES;
    textField.inputAccessoryView = mypickerToolbar;
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return pickerDataFood.count;
    
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
   return [pickerDataFood objectAtIndex:row];

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    if (pickerView == self.pickerFood){
        thisLabel.text = [pickerDataFood objectAtIndex:row];
    }
    
    
    return thisLabel;
}
    


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.food.text = [pickerDataFood objectAtIndex:row];
}


- (void) pickerDoneClicked{

    [self.food resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.food resignFirstResponder];
    [self.email resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.passwordAgainField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
}





///////////////////////////////////////////



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self.usernameField becomeFirstResponder];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.email) {
        [self.email becomeFirstResponder];
    }
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    if (textField == self.passwordField) {
        [self.passwordAgainField becomeFirstResponder];
    }
    if (textField == self.passwordAgainField) {
        [self.passwordAgainField resignFirstResponder];
        [self processFieldEntries];
    }
    
    return YES;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)createAccountPressed:(id)sender {
    [self dismissKeyboard];
    [self processFieldEntries];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissKeyboard];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Sign Up

- (void)processFieldEntries {
    // Check that we have a non-zero username and passwords.
    // Compare password and passwordAgain for equality
    // Throw up a dialog that tells them what they did wrong if they did it wrong.
    NSString *email = self.email.text;
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *passwordAgain = self.passwordAgainField.text;
    NSString *errorText = @"Please ";
    NSString *usernameBlankText = @"enter a username";
    NSString *passwordBlankText = @"enter a password";
    NSString *joinText = @", and ";
    NSString *passwordMismatchText = @"enter the same password twice";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (email.length == 0 || username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (email.length == 0) {
            [self.email becomeFirstResponder];
        }
        if (passwordAgain.length == 0) {
            [self.passwordAgainField becomeFirstResponder];
        }
        if (password.length == 0) {
            [self.passwordField becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.usernameField becomeFirstResponder];
        }
        
        if (username.length == 0) {
            errorText = [errorText stringByAppendingString:usernameBlankText];
        }
        
        if (password.length == 0 || passwordAgain.length == 0) {
            if (username.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:passwordBlankText];
        }
    } else if ([password compare:passwordAgain] != NSOrderedSame) {
        // We have non-zero strings.
        // Check for equal password strings.
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordMismatchText];
        [self.passwordField becomeFirstResponder];
    }
    
    if (textError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    // Everything looks good; try to log in.
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Signing You Up";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    // Call into an object somewhere that has code for setting up a user.
    // The app delegate cares about this, but so do a lot of other objects.
    // For now, do this inline.
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email; 
    NSString *newString = [self.food.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [user setObject: newString forKey:(@"preference")];
    NSLog(@"newString is %@", newString);
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            [activityView.activityIndicator stopAnimating];
            [activityView removeFromSuperview];
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.usernameField becomeFirstResponder];
            return;
        }
        PFInstallation *myinstallation = [PFInstallation currentInstallation];
        [myinstallation setObject:user forKey:(@"User")];
        
        [myinstallation setObject:@[newString] forKey:@"channels"];
        [myinstallation saveEventually];
        
        NSLog(@"here");
        //[myinstallation saveInBackground];
        
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate newUserViewControllerDidSignup:self];
        [self performSegueWithIdentifier:@"login" sender:self];
    }];
}

#pragma mark -
#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
@end
