//
//  Reference+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/19/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "Reference+Spread.h"



@implementation Reference (Spread)

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Reference* reference = (Reference*)[super objectWithDict:dict inContext:context];
    reference.referenceID = dict[[self jsonIDKey]];
    reference.referenceURL = dict[@"url"];
    
	return reference;
}

+ (NSString *)modelIDKey
{
    return @"referenceID";
}

+ (NSString *)jsonIDKey
{
    return @"id";
}


@end
