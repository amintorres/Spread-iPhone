//
//  NSDictionary+Utilities.m
//  Spread
//
//  Created by Joseph Lin on 8/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSDictionary+Utilities.h"


@implementation NSDictionary (Utilities)


- (NSString*)paramString
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]]) {
            key = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            obj = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, obj];
        [array addObject:pair];
    }];
    
    NSString* string = [array componentsJoinedByString:@"&"];
    return string;
}

@end
