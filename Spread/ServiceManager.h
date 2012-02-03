//
//  ServiceManager.h
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
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



@interface ServiceManager : NSObject <RKObjectLoaderDelegate, RKRequestDelegate, RKManagedObjectCache>

@property (strong, nonatomic) NSArray* userPhotos;
@property (strong, nonatomic) NSArray* popularPhotos;
@property (strong, nonatomic) NSArray* recentPhotos;

+ (ServiceManager*)sharedManager;
+ (NSArray*)photosOfType:(PhotoType)type;
+ (BOOL)isSessionValid;

+ (void)setupRestKit;

+ (RKObjectLoader*)loginWithUsername:(NSString*)username password:(NSString*)password;
+ (RKObjectLoader*)loadUserInfoFromServer;
+ (void)logout;
+ (void)requestInviteWithEmail:(NSString*)email name:(NSString*)name;
+ (RKObjectLoader*)loadUserPhotos;
+ (RKObjectLoader*)loadPopularPhotos;
+ (RKObjectLoader*)loadRecentPhotos;
+ (RKObjectLoader*)postPhoto:(Photo*)photo imageData:(NSData*)imageData;
+ (RKObjectLoader*)updatePhoto:(Photo*)photo;
+ (RKObjectLoader*)deletePhoto:(Photo*)photo;


@end
