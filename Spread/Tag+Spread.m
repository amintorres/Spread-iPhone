//
//  Tag+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "Tag+Spread.h"


@implementation Tag (Spread)

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    
}


+ (NSSet*)tagsFromCSV:(NSString*)csvString
{
    NSArray* strings = [csvString componentsSeparatedByString:@","];
    NSMutableSet* tags = [NSMutableSet setWithCapacity:[strings count]];
    
    for ( NSString* string in strings )
    {
        NSString* trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name = %@", trimmedString];
        
        Tag* tag = [Tag objectWithPredicate:predicate];
        if ( !tag )
        {
            tag = [Tag object];
            tag.name = trimmedString;
        }
        
        [tags addObject:tag];
    }
    
    return tags;
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
