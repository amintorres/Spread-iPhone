//
//  UIFont+Spread.m
//  Spread
//
//  Created by Joseph Lin on 8/19/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "UIFont+Spread.h"


@implementation UIFont (Spread)

+ (UIFont *)appFontOfSize:(CGFloat)fontSize
{
    UIFont* font = [UIFont fontWithName:kAppFontName size:fontSize];
    return font;
}

+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize
{
    UIFont* font = [UIFont fontWithName:kBoldAppFontName size:fontSize];
    return font;
}

+ (UIFont *)italicAppFontOfSize:(CGFloat)fontSize
{
    UIFont* font = [UIFont fontWithName:kItalicAppFontName size:fontSize];
    return font;   
}


#pragma mark -

+ (NSString *)systemFontName
{
    static NSString* systemFontName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIFont* font = [UIFont systemFontOfSize:10];
        systemFontName = [font fontName];
    });
    return systemFontName;
}

+ (NSString *)boldSystemFontName
{
    static NSString* boldSystemFontName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIFont* font = [UIFont boldSystemFontOfSize:10];
        boldSystemFontName = [font fontName];
    });
    return boldSystemFontName;
}

+ (NSString *)italicSystemFontName
{
    static NSString* italicSystemFontName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIFont* font = [UIFont italicSystemFontOfSize:10];
        italicSystemFontName = [font fontName];
    });
    return italicSystemFontName;
}

@end
