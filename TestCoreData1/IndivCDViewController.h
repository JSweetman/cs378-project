//
//  IndivCDViewController.h
//  TestCoreData1
//
//  Created by CHRISTOPHER METCALF on 10/7/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface IndivCDViewController : UIViewController

@property DataModel *hey; 
@property (weak, nonatomic) IBOutlet UILabel *event;
@property (weak, nonatomic) IBOutlet UILabel *where;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *food;

@end
