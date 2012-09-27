//
//  Tag+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "Tag+Spread.h"


@implementation Tag (Spread)

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Tag* tag = (Tag*)[super objectWithDict:dict inContext:context];
    tag.tagID = dict[[self jsonIDKey]];
    tag.name = dict[@"name"];
    
	return tag;
}

+ (NSString *)modelIDKey
{
    return @"tagID";
}

+ (NSString *)jsonIDKey
{
    return @"id";
}


@end
