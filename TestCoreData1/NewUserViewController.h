//
//  NewUserViewController.h
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 11/18/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NewUserViewController;

@protocol NewUserViewControllerDelegate <NSObject>

- (void)newUserViewControllerDidSignup:(NewUserViewController *)controller;

@end

@interface NewUserViewController : UIViewController

@property (nonatomic, weak) id<NewUserViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerFood;
@property (weak, nonatomic) IBOutlet UITextField *food;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *passwordAgainField;

@end
