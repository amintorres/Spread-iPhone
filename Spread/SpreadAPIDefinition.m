//
//  SpreadAPIDefinition.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "SpreadAPIDefinition.h"
#import "User+Spread.h"



@implementation SpreadAPIDefinition


#pragma mark -
#pragma mark URL

+ (NSString*)baseURL
{
    static NSString* const baseURL = @"http://joinspread.com";
    return baseURL;
}


#pragma mark -
#pragma mark User Paths

+ (NSString*)loginPath
{
    static NSString* const loginPath = @"/user_sessions.json";
    return loginPath;
}

+ (NSString*)logoutPath
{
    static NSString* const logoutPath = @"/logout";
    return logoutPath;
}

+ (NSString*)userInfoPath
{
    NSString* userInfoPath = [NSString stringWithFormat:@"/users/me.json?%@", [self userCredentialsQuery]];
    return userInfoPath;
}


#pragma mark -
#pragma mark Photo Paths

+ (NSString*)allPhotosPath
{
    NSString* allPhotosPath = [NSString stringWithFormat:@"/photos/uploaded.json?%@", [self userCredentialsQuery]];
    return allPhotosPath;
}

+ (NSString*)postPhotoPath
{
    NSString* postPhotoPath = [NSString stringWithFormat:@"/photos?%@", [self userCredentialsQuery]];
    return postPhotoPath;
}

+ (NSString*)putPhotoPath
{
    NSString* putPhotoPath = [NSString stringWithFormat:@"/photos/:photoID?%@", [self userCredentialsQuery]];
    return putPhotoPath;
}

+ (NSString*)deletePhotoPath
{
    NSString* deletePhotoPath = [NSString stringWithFormat:@"/photos/:photoID?%@", [self userCredentialsQuery]];
    return deletePhotoPath;
}


#pragma mark -
#pragma mark Query

+ (NSString*)userCredentialsQuery
{
    NSString* storedToken = [User oauthToken];
    if ( storedToken )
    {
        NSString* userCredentials = [NSString stringWithFormat:@"user_credentials=%@", [User oauthToken]];
        return userCredentials;
    }
    else
    {
        return nil;
    }
}



@end
