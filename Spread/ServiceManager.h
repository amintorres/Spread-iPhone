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

extern NSString * const SpreadDidLoginNotification;
extern NSString * const SpreadDidLoadUserInfoNotification;
extern NSString * const SpreadDidLoadPhotosNotification;
extern NSString * const SpreadDidRequestInviteNotification;
extern NSString * const SpreadDidStartSendingPhotoNotification;
extern NSString * const SpreadDidSendPhotoBodyDataNotification;
extern NSString * const SpreadDidFinishSendingPhotoNotification;
extern NSString * const SpreadDidFailSendingPhotoNotification;
extern NSString * const SpreadDidFailNotification;


typedef enum {
    PhotoTypeUsers = 0,
    PhotoTypePopular,
    PhotoTypeRecent,
}PhotoType;

typedef void (^ServiceManagerHandler)(id response, BOOL success, NSError *error);



@interface ServiceManager : NSObject

@property (strong, nonatomic) NSString* oauthToken;

+ (ServiceManager*)sharedManager;

- (BOOL)isSessionValid;
- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(ServiceManagerHandler)completion;
- (void)loginWithFacebookToken:(NSString*)token completion:(ServiceManagerHandler)completion;

- (void)loadRecentPhotosWithHandler:(ServiceManagerHandler)completion;
- (void)loadPopularPhotosWithHandler:(ServiceManagerHandler)completion;

//+ (void)loginWithEmail:(NSString*)email password:(NSString*)password response:^(BOOL success)response;

//@property (strong, nonatomic) NSArray* userPhotos;
//@property (strong, nonatomic) NSArray* popularPhotos;
//@property (strong, nonatomic) NSArray* recentPhotos;
//
//+ (NSArray*)photosOfType:(PhotoType)type;


//+ (RKObjectLoader*)loginWithUsername:(NSString*)username password:(NSString*)password;
//+ (RKObjectLoader*)loadUserInfoFromServer;
//+ (void)logout;
//+ (void)requestInviteWithEmail:(NSString*)email name:(NSString*)name;
//+ (RKObjectLoader*)loadUserPhotos;
//+ (RKObjectLoader*)loadPopularPhotos;
//+ (RKObjectLoader*)loadRecentPhotos;
//+ (RKObjectLoader*)postPhoto:(Photo*)photo imageData:(NSData*)imageData;
//+ (RKObjectLoader*)updatePhoto:(Photo*)photo;
//+ (RKObjectLoader*)deletePhoto:(Photo*)photo;


@end
