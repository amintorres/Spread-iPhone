//
//  NSNumber+Spread.m
//  Spread
//
//  Created by Joseph Lin on 9/29/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSNumber+Spread.h"


@implementation NSNumber (Spread)

+ (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter* _currencyFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currencyFormatter = [NSNumberFormatter new];
        _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        _currencyFormatter.currencyCode = @"USD";
    });
    return _currencyFormatter;
}

- (NSString *)currencyString
{
    return [[NSNumber currencyFormatter] stringFromNumber:self];
}

@end
