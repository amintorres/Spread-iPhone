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
#import "ConnectionHelper.h"
#import "Request+Spread.h"

extern NSString * const SpreadNotificationUploadProgressChanged;
extern NSString * const SpreadNotificationUploadFinished;

typedef void (^ServiceManagerHandler)(id response, BOOL success, NSError *error);



@interface ServiceManager : NSObject

@property (nonatomic, strong) NSString* oauthToken;
@property (nonatomic, strong) NSString* currentUserID;
@property (nonatomic, strong) NSMutableArray *uploadQueue;

+ (ServiceManager*)sharedManager;

- (BOOL)isSessionValid;
- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(ServiceManagerHandler)completion;
- (void)loginWithFacebookToken:(NSString*)token completion:(ServiceManagerHandler)completion;
- (void)logout;
- (void)loadEntityWithID:(NSString*)entityID completion:(ServiceManagerHandler)completion;

- (void)loadRecentPhotosWithHandler:(ServiceManagerHandler)completion;
- (void)loadPopularPhotosWithHandler:(ServiceManagerHandler)completion;
- (void)loadUserPhotosWithHandler:(ServiceManagerHandler)completion;

- (void)loadRequestsWithHandler:(ServiceManagerHandler)completion;

- (void)postUserPhoto:(NSData *)imageData name:(NSString*)name csvTags:(NSString*)csvTags description:(NSString*)description completionHandler:(ServiceManagerHandler)completion;
- (void)postPhoto:(NSData *)imageData toRequest:(Request *)photoRequest completionHandler:(ServiceManagerHandler)completion;
- (void)sendPostRequest:(NSURLRequest *)request completionHandler:(ServiceManagerHandler)completion;
- (void)updatePhoto:(Photo *)photo;
- (void)deletePhoto:(Photo *)photo;

- (NSString*)supportEmail;

@end
