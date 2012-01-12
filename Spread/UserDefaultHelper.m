//
//  UserDefaultHelper.m
//  Spread
//
//  Created by Joseph Lin on 1/12/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "UserDefaultHelper.h"

static NSString* const kUserDefaultsKeyOauthToken = @"kUserDefaultsKeyOauthToken";



@implementation UserDefaultHelper


+ (void)setOauthToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserDefaultsKeyOauthToken];
}

+ (NSString*)oauthToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyOauthToken];
}


@end
