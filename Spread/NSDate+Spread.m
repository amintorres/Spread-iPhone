//
//  NSDate+Spread.m
//  Spread
//
//  Created by Joseph Lin on 8/9/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSDate+Spread.h"


@implementation NSDate (Spread)

+ (NSDateFormatter *)dateAndTimeFormatter
{
    static NSDateFormatter* _dateAndTimeFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateAndTimeFormatter = [NSDateFormatter new];
        _dateAndTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _dateAndTimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return _dateAndTimeFormatter;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter* _dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return _dateFormatter;
}

+ (NSDateFormatter *)displayDateFormatter
{
    static NSDateFormatter* _displayDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _displayDateFormatter = [NSDateFormatter new];
        _displayDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _displayDateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _displayDateFormatter.timeStyle = NSDateFormatterNoStyle;
    });
    return _displayDateFormatter;
}

+ (NSDate *)dateFromServerString:(NSString *)string
{
    NSDate* date = [[self dateAndTimeFormatter] dateFromString:string];
    
    if (!date)
    {
        date = [[self dateFormatter] dateFromString:string];
    }
    
    return date;
}

- (NSString *)dateString
{
    return [[NSDate displayDateFormatter] stringFromDate:self];
}

@end
