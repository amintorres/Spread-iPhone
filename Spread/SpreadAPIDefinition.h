//
//  SpreadAPIDefinition.h
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SpreadAPIDefinition : NSObject


// URL
+ (NSString*)baseURL;


// Invite
+ (NSString*)invitePath;

// User Path
+ (NSString*)loginPath;
+ (NSString*)logoutPath;
+ (NSString*)userInfoPath;

// Photo Path
+ (NSString*)userPhotosPath;
+ (NSString*)postPhotoPath;
+ (NSString*)putPhotoPath;
+ (NSString*)deletePhotoPath;
+ (NSString*)popularPhotosPath;
+ (NSString*)recentPhotosPath;


// Query

+ (NSString*)userCredentialsQuery;


// Support Email
+ (NSString*)supportEmail;


@end
