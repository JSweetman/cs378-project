//
//  AddViewController.h
//  TestCoreData1
//
//  Created by CHRISTOPHER METCALF on 10/4/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface AddViewController : UIViewController<DataModelProtocol,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerFood;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerWhere;
- (IBAction)whenButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *event;
@property (weak, nonatomic) IBOutlet UITextField *where;


//@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *food;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UILabel *message_label;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveGo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
- (IBAction)pkrValueChange:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UILabel *pickedTime;
@property (weak, nonatomic) IBOutlet UILabel *pickedDate;

@property(weak, nonatomic) NSString* timeAMPM;
@end
