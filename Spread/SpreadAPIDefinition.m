//
//  SpreadAPIDefinition.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "SpreadAPIDefinition.h"



@implementation SpreadAPIDefinition


#pragma mark -
#pragma mark URL

+ (NSString*)baseURL
{
    static NSString* baseURL = @"http://joinspread.com";
    return baseURL;
}


#pragma mark -
#pragma mark Path

+ (NSString*)allPhotosPath
{
    NSString* allPhotosPath = [NSString stringWithFormat:@"/photos.json?%@", [self userCredentials]];
    return allPhotosPath;
}


#pragma mark -
#pragma mark Query

+ (NSString*)userCredentials
{
    NSString* token = @"wAS4BLjaaAnmWdw98qi";
    NSString* userCredentials = [NSString stringWithFormat:@"user_credentials=%@", token];
    return userCredentials;
}



@end
