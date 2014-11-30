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
        // Disable automatic adjustment, as we want to occupy all screen real estate
        self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self.usernameField resignFirstResponder];
    [self.passwordAgainField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    //[self.pickerFood resignFirstResponder];
    //[self.pickedTime resignFirstResponder];
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
    if (username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
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
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    NSString *newString = [self.food.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [installation addUniqueObject:newString forKey:@"channels"];
    [installation saveInBackground];
    
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
        
        // Success!
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
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat scrollViewOffsetY = (keyboardFrame.size.height -
                                 (CGRectGetHeight(self.view.bounds) -
                                  CGRectGetMaxY(self.createAccountButton.frame)));
    // Check if scrolling needed
    if (scrollViewOffsetY < 0) {
        return;
    }
    
    // Fix the icon and logo if necessary
    CGFloat bottomViewToCheck = self.iconImageView.frame.origin.y + self.iconImageView.frame.size.height;
    // Only if the logo is party visible (happens for 3.5-inch device)
    if (scrollViewOffsetY > bottomViewToCheck) {
        return;
    }
    CGFloat yIconOffset = MAX(scrollViewOffsetY, self.iconImageViewOriginalY);
    __block CGRect iconFrame = self.iconImageView.frame;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointMake(0.0f, scrollViewOffsetY) animated:NO];
                         
                         if (yIconOffset != iconFrame.origin.y) {
                             // Move icon
                             iconFrame.origin.y = yIconOffset + 20.0f;
                             self.iconImageView.frame = iconFrame;
                             
                             // Move logo with respect to the icon and
                             // decrease distance between them slightly
                             // to avoid overlap with the first text field.
                             CGRect logoFrame = self.logoImageView.frame;
                             logoFrame.origin.y = CGRectGetMinY(iconFrame) + self.iconLogoOffsetY - 7.0f;
                             self.logoImageView.frame = logoFrame;
                         }
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointZero animated:NO];
                         
                         if (self.iconImageView.frame.origin.y != self.iconImageViewOriginalY) {
                             CGRect iconFrame = self.iconImageView.frame;
                             iconFrame.origin.y = self.iconImageViewOriginalY;
                             self.iconImageView.frame = iconFrame;
                             
                             CGRect logoFrame = self.logoImageView.frame;
                             logoFrame.origin.y = self.iconImageViewOriginalY + self.iconLogoOffsetY;
                             self.logoImageView.frame = logoFrame;
                         }
                     }
                     completion:nil];
}

@end
