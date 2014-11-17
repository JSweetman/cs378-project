//
//  DataModel.h
//  TestCoreData1
//
//  Created by CHRISTOPHER METCALF on 10/4/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <Foundation/Foundation.h>
// Define the protocol
@protocol DataModelProtocol <NSObject>

@required
-(void)modifiedData:(NSString*)data;

@end

@interface DataModel : NSObject

@property(strong, nonatomic) NSString *event;
@property(strong, nonatomic) NSString *where;
@property(strong, nonatomic) NSString *time;
@property(strong, nonatomic) NSString *food;
@property(strong, nonatomic) NSString *pickedTime;
@property(strong, nonatomic) NSString *pickedDate;
@property(strong, nonatomic) NSDate *date;

@property (nonatomic, strong) id <DataModelProtocol> delegate;

-(void)saveWithEvent:(NSString*) event andWhere:(NSString*) where andTime:(NSString*) time andFood:(NSString*) food;

@end

//@interface DataModel : NSMutableArray

