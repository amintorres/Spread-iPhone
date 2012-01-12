//
//  ServiceManager.h
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Photo.h"

static NSString* SpreadDidLoginNotification = @"SpreadDidLoginNotification";
static NSString* ServiceManagerDidLoadPhotosNotification = @"ServiceManagerDidLoadPhotosNotification";


@interface ServiceManager : NSObject <RKObjectLoaderDelegate, RKRequestDelegate>

@property (strong, nonatomic) NSArray* allPhotos;

+ (ServiceManager*)sharedManager;
+ (NSArray*)allPhotos;
+ (void)logout;
+ (void)loginWithUsername:(NSString*)username password:(NSString*)password;
+ (void)loadDataFromServer;
+ (void)postPhoto:(Photo*)photo imageData:(NSData*)imageData;
+ (void)updatePhoto:(Photo*)photo;
+ (void)deletePhoto:(Photo*)photo;


@end
