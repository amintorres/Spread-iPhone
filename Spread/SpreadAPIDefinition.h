//
//  SpreadAPIDefinition.h
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SpreadAPIDefinition : NSObject


// URL
+ (NSString*)baseURL;


// Path
+ (NSString*)loginPath;
+ (NSString*)logoutPath;
+ (NSString*)allPhotosPath;
+ (NSString*)postPhotoPath;
+ (NSString*)putPhotoPath;
+ (NSString*)deletePhotoPath;


// Query

+ (NSString*)userCredentialsQuery;


@end
