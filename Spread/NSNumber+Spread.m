//
//  NSNumber+Spread.m
//  Spread
//
//  Created by Joseph Lin on 9/29/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSNumber+Spread.h"
#import <CoreText/CTStringAttributes.h>



@implementation NSNumber (Spread)

+ (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter* _currencyFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currencyFormatter = [NSNumberFormatter new];
        _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        _currencyFormatter.currencyCode = @"USD";
        _currencyFormatter.maximumFractionDigits = 0;
    });
    return _currencyFormatter;
}

- (NSString *)currencyString
{
    return [[NSNumber currencyFormatter] stringFromNumber:self];
}

- (NSAttributedString *)attributedCurrencyStringWithBaseFont:(UIFont *)font
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self currencyString]
                                                                                         attributes:@{NSFontAttributeName:font}];
    [attributedString setAttributes:@{
    (id)kCTSuperscriptAttributeName:@2,
                NSFontAttributeName:[UIFont fontWithName:font.fontName size:font.pointSize * 0.5]}
                              range:NSMakeRange(0, 1)];
    return attributedString;
}

@end
