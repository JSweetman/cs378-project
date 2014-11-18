//
//  LogInViewController.h
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 11/18/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(LoginViewController *)controller;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end


