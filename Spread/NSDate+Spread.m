//
//  NSDate+Spread.m
//  Spread
//
//  Created by Joseph Lin on 8/9/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSDate+Spread.h"


@implementation NSDate (Spread)

+ (NSDate *)dateFromServerString:(NSString *)string
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ss'Z'";
    NSDate* date = [formatter dateFromString:string];
    return date;
}

@end
