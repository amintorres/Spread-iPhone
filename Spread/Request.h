//
//  Request.h
//  Spread
//
//  Created by Joseph Lin on 9/29/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Request : NSManagedObject

@property (nonatomic, retain) NSString * formattedAmount;
@property (nonatomic, retain) NSString * requestDescription;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSNumber * durationInDays;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * remaining;
@property (nonatomic, retain) NSNumber * requestID;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) User *requester;

@end
