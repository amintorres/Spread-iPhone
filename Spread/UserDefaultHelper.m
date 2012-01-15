//
//  UserDefaultHelper.m
//  Spread
//
//  Created by Joseph Lin on 1/12/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "UserDefaultHelper.h"

static NSString* const kUserDefaultsKeyShouldStoreDetails = @"kUserDefaultsKeyShouldStoreDetails";
static NSString* const kUserDefaultsKeyStoredTitle = @"kUserDefaultsKeyStoredTitle";
static NSString* const kUserDefaultsKeyStoredTags = @"kUserDefaultsKeyStoredTags";
static NSString* const kUserDefaultsKeyStoredDescription = @"kUserDefaultsKeyStoredDescription";



@implementation UserDefaultHelper


+ (void)setShouldStoreDetails:(BOOL)storeDetails
{
    [[NSUserDefaults standardUserDefaults] setBool:storeDetails forKey:kUserDefaultsKeyShouldStoreDetails];
    
    if ( !storeDetails )
    {
        [self clearStoredDetails];
    }
}

+ (BOOL)shouldStoreDetails
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyShouldStoreDetails];
}

+ (void)clearStoredDetails
{
    [UserDefaultHelper setStoredTitle:nil];
    [UserDefaultHelper setStoredTags:nil];
    [UserDefaultHelper setStoredDescription:nil];     
}


+ (void)setStoredTitle:(NSString*)title
{
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:kUserDefaultsKeyStoredTitle];
}

+ (NSString*)storedTitle
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyStoredTitle];
}

+ (void)setStoredTags:(NSString*)tags
{
    [[NSUserDefaults standardUserDefaults] setObject:tags forKey:kUserDefaultsKeyStoredTags];
}

+ (NSString*)storedTags
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyStoredTags];
}

+ (void)setStoredDescription:(NSString*)description
{
    [[NSUserDefaults standardUserDefaults] setObject:description forKey:kUserDefaultsKeyStoredDescription];
}

+ (NSString*)storedDescription
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyStoredDescription];
}




@end
