//
//  DataModel.m
//  TestCoreData1
//
//  Created by CHRISTOPHER METCALF on 10/4/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
-(void)saveWithEvent:(NSString*) event andWhere:(NSString*) where andTime:(NSString*) time andFood:(NSString*) food;


{
    if ([event length] > 0 && [where length] > 0 && [time length] > 0 && [food length] > 0){
        
        //NSString *concat = [[NSString alloc] initWithFormat: @"%@ - %@", name, city];
        //create concat and call modifiedata
        NSString *dataSaved = @"Data has been saved";
        [self.delegate modifiedData:dataSaved];
    }
    else{
        NSString *noParameters = @"You must enter a value for every field!!";
        [self.delegate modifiedData:noParameters];
    }
    
}@end
