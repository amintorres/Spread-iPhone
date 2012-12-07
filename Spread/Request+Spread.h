//
//  Request+Spread.h
//  Spread
//
//  Created by Joseph Lin on 9/29/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSManagedObject+Utilities.h"
#import "Request.h"


@interface Request (Spread)

// Override: Clears requests deleted on the server.
+ (void)objectsWithArray:(NSArray*)array inContext:(NSManagedObjectContext*)context completion:(void(^)(NSArray* objects))completion;

+ (NSNumber *)totalAmount;
- (NSUInteger)daysLeft;

@end
