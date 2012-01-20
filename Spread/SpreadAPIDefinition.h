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


// User Paths
+ (NSString*)loginPath;
+ (NSString*)logoutPath;
+ (NSString*)userInfoPath;

// Photo Paths
+ (NSString*)allPhotosPath;
+ (NSString*)postPhotoPath;
+ (NSString*)putPhotoPath;
+ (NSString*)deletePhotoPath;


// Query

+ (NSString*)userCredentialsQuery;


@end
