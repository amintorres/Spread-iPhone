//
//  NSUserDefaults+Spread.m
//  Spread
//
//  Created by Joseph Lin on 12/16/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSUserDefaults+Spread.h"

static NSString* const kUserDefaultsKeyShouldStoreDetails = @"kUserDefaultsKeyShouldStoreDetails";
static NSString* const kUserDefaultsKeyStoredTitle = @"kUserDefaultsKeyStoredTitle";
static NSString* const kUserDefaultsKeyStoredTags = @"kUserDefaultsKeyStoredTags";
static NSString* const kUserDefaultsKeyStoredDescription = @"kUserDefaultsKeyStoredDescription";


@implementation NSUserDefaults (Spread)

- (void)setShouldStoreDetails:(BOOL)shouldStoreDetails
{
    [[NSUserDefaults standardUserDefaults] setBool:shouldStoreDetails forKey:kUserDefaultsKeyShouldStoreDetails];
    
    if (!shouldStoreDetails)
    {
        self.storedTitle = nil;
        self.storedTags = nil;
        self.storedDescription = nil;
    }
}

- (BOOL)shouldStoreDetails
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyShouldStoreDetails];
}

- (void)setStoredTitle:(NSString *)storedTitle
{
    [[NSUserDefaults standardUserDefaults] setObject:storedTitle forKey:kUserDefaultsKeyStoredTitle];
}

- (NSString*)storedTitle
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyStoredTitle];
}

- (void)setStoredTags:(NSString *)storedTags
{
    [[NSUserDefaults standardUserDefaults] setObject:storedTags forKey:kUserDefaultsKeyStoredTags];
}

- (NSString*)storedTags
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyStoredTags];
}

- (void)setStoredDescription:(NSString *)storedDescription
{
    [[NSUserDefaults standardUserDefaults] setObject:storedDescription forKey:kUserDefaultsKeyStoredDescription];
}

- (NSString*)storedDescription
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyStoredDescription];
}


@end
