//
//  NSNumber+Spread.h
//  Spread
//
//  Created by Joseph Lin on 9/29/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Spread)

+ (NSNumberFormatter *)currencyFormatter;
- (NSString *)currencyString;
- (NSAttributedString *)attributedCurrencyStringWithBaseFont:(UIFont *)font;

@end
