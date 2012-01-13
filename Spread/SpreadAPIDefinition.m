//
//  SpreadAPIDefinition.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "SpreadAPIDefinition.h"
#import "UserDefaultHelper.h"



@implementation SpreadAPIDefinition


#pragma mark -
#pragma mark URL

+ (NSString*)baseURL
{
    static NSString* const baseURL = @"http://joinspread.com";
    return baseURL;
}


#pragma mark -
#pragma mark Path

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

+ (NSString*)allPhotosPath
{
    NSString* allPhotosPath = [NSString stringWithFormat:@"/users/1/photos.json?%@", [self userCredentialsQuery]];
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
//    NSString* token = @"wAS4BLjaaAnmWdw98qi";
    NSString* userCredentials = [NSString stringWithFormat:@"user_credentials=%@", [UserDefaultHelper oauthToken]];
    return userCredentials;
}



@end
