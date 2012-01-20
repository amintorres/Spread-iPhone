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


@interface ServiceManager : NSObject <RKObjectLoaderDelegate, RKRequestDelegate>

@property (strong, nonatomic) NSArray* allPhotos;

+ (ServiceManager*)sharedManager;
+ (NSArray*)allPhotos;
+ (BOOL)isSessionValid;

+ (void)setupRestKit;

+ (void)loginWithUsername:(NSString*)username password:(NSString*)password;
+ (void)loadUserInfoFromServer;
+ (void)logout;
+ (void)requestInviteWithEmail:(NSString*)email name:(NSString*)name;
+ (void)loadDataFromServer;
+ (void)postPhoto:(Photo*)photo imageData:(NSData*)imageData;
+ (void)updatePhoto:(Photo*)photo;
+ (void)deletePhoto:(Photo*)photo;


@end
