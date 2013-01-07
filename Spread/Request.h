//
//  Request.h
//  Spread
//
//  Created by Joseph Lin on 1/6/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, User;

@interface Request : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * durationInDays;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * formattedAmount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * remaining;
@property (nonatomic, retain) NSString * requestDescription;
@property (nonatomic, retain) NSNumber * requestID;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) User *requester;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Request (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
