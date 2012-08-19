//
//  UIFont+Spread.h
//  Spread
//
//  Created by Joseph Lin on 8/19/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppFontName        @"OpenSans"
#define kBoldAppFontName    @"OpenSans-Bold"
#define kItalicAppFontName  @"OpenSans-Italic"


@interface UIFont (Spread)

+ (UIFont *)appFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize;
+ (UIFont *)italicAppFontOfSize:(CGFloat)fontSize;

+ (NSString *)systemFontName;
+ (NSString *)boldSystemFontName;
+ (NSString *)italicSystemFontName;

@end
