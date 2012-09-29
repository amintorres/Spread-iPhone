//
//  Request+Spread.m
//  Spread
//
//  Created by Joseph Lin on 9/29/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "Request+Spread.h"
#import "User+Spread.h"
#import "NSDate+Spread.h"



@implementation Request (Spread)


+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Request* request = (Request*)[super objectWithDict:dict inContext:context];
    request.requestID = dict[[self jsonIDKey]];
    request.createdDate = [NSDate dateFromServerString:dict[@"created_at"]];
    request.updatedDate = [NSDate dateFromServerString:dict[@"updated_at"]];
    request.startDate = [NSDate dateFromServerString:dict[@"start_at"]];
    request.endDate = [NSDate dateFromServerString:dict[@"end_at"]];
    request.durationInDays = @([dict[@"duration"] integerValue]);
    request.name = dict[@"name"];
    request.requestDescription = dict[@"description"];
    request.amount = [NSDecimalNumber decimalNumberWithMantissa:[dict[@"amount"] integerValue] exponent:-2 isNegative:NO];
    request.formattedAmount = dict[@"formatted_amount"];
    request.quantity = @([dict[@"quantity"] integerValue]);
    request.remaining = @([dict[@"remaining"] integerValue]);
    
    NSDictionary* entity = dict[@"entity"];
    request.requester = (User*)[User objectWithDict:entity inContext:context];
    
	return request;
}

+ (NSString *)modelIDKey
{
    return @"requestID";
}

+ (NSString *)jsonIDKey
{
    return @"id";
}


#pragma mark -

+ (NSNumber *)totalAmount
{
    NSArray* allObjects = [self allObjectsInContext:[self mainMOC]];
    NSNumber* sum = [allObjects valueForKeyPath:@"@sum.amount"];
    return sum;
}



@end
