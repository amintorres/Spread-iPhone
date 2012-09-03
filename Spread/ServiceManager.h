//
//  ServiceManager.h
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
#import "User.h"


typedef enum {
    PhotoTypeUsers = 0,
    PhotoTypePopular,
    PhotoTypeRecent,
}PhotoType;

typedef void (^ServiceManagerHandler)(id response, BOOL success, NSError *error);



@interface ServiceManager : NSObject

@property (strong, nonatomic) NSString* oauthToken;
@property (strong, nonatomic) NSString* currentUserID;

+ (ServiceManager*)sharedManager;

- (BOOL)isSessionValid;
- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(ServiceManagerHandler)completion;
- (void)loginWithFacebookToken:(NSString*)token completion:(ServiceManagerHandler)completion;
- (void)logout;
- (void)loadEntityWithID:(NSString*)entityID completion:(ServiceManagerHandler)completion;

- (void)loadRecentPhotosWithHandler:(ServiceManagerHandler)completion;
- (void)loadPopularPhotosWithHandler:(ServiceManagerHandler)completion;
- (void)loadUserPhotosWithHandler:(ServiceManagerHandler)completion;

@end
