//
//  Tag+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "Tag+Spread.h"


@implementation Tag (Spread)


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


@end
