//
//  ServiceManager.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ServiceManager.h"
#import "NSDictionary+Utilities.h"
#import "User+Spread.h"
#import "Photo+Spread.h"
#import "FacebookSDK.h"

NSString * const SpreadDidLoginNotification = @"SpreadDidLoginNotification";
NSString * const SpreadDidLoadUserInfoNotification = @"SpreadDidLoadUserInfoNotification";
NSString * const SpreadDidLoadPhotosNotification = @"SpreadDidLoadPhotosNotification";
NSString * const SpreadDidRequestInviteNotification = @"SpreadDidRequestInviteNotification";
NSString * const SpreadDidStartSendingPhotoNotification = @"SpreadDidStartSendingPhotoNotification";
NSString * const SpreadDidSendPhotoBodyDataNotification = @"SpreadDidSendPhotoBodyDataNotification";
NSString * const SpreadDidFinishSendingPhotoNotification = @"SpreadDidFinishSendingPhotoNotification";
NSString * const SpreadDidFailSendingPhotoNotification = @"SpreadDidFailSendingPhotoNotification";
NSString * const SpreadDidFailNotification = @"SpreadDidFailNotification";


static NSString* const baseURL = @"http://dev.spread.cm";
static NSString* const loginPath = @"api/v1/users/login.json";
static NSString* const facebookLoginPath = @"api/v1/fb_authenticate";
static NSString* const entityInfoPath = @"api/v1/entities/%@";
static NSString* const recentPhotoPath = @"api/v1/news_photos/recent.json";
static NSString* const popularPhotoPath = @"api/v1/news_photos/popular.json";
static NSString* const userPhotoPath = @"api/v1/requests/%@/request_photos.json";


@interface ServiceManager ()

@end



@implementation ServiceManager

//@synthesize userPhotos, popularPhotos, recentPhotos;


#pragma mark - Singleton

+ (ServiceManager*)sharedManager
{
    static ServiceManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ServiceManager alloc] init];
    });
    
    return _sharedManager;
}


#pragma mark - Login/Logout

- (BOOL)isSessionValid
{
    return ( self.oauthToken != nil );
}

- (void)sendLoginRequest:(NSURLRequest*)request completion:(ServiceManagerHandler)completion
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (data)
        {
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            NSLog(@"result: %@", result);
            
            self.oauthToken = [result objectForKey:@"authentication_token"];
            self.currentUserID = [result objectForKey:@"person_id"];
            
            [self loadEntityWithID:self.currentUserID completion:completion];
        }
        else
        {
            NSLog(@"error: %@", error);
            completion(nil, NO, error);
        }
    }];
}

- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(ServiceManagerHandler)completion
{
    NSURL *URL = [[NSURL URLWithString:baseURL] URLByAppendingPathComponent:loginPath];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSString *param = [[NSDictionary dictionaryWithObjectsAndKeys:
                        email, @"session[email]",
                        password, @"session[password]",
                        nil] paramString];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];

    [self sendLoginRequest:request completion:completion];
}

- (void)loginWithFacebookToken:(NSString*)token completion:(ServiceManagerHandler)completion
{
    NSURL *URL = [[NSURL URLWithString:baseURL] URLByAppendingPathComponent:facebookLoginPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSString *param = [[NSDictionary dictionaryWithObjectsAndKeys:
                        token, @"fb_access_token",
                        nil] paramString];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendLoginRequest:request completion:completion];
}

- (void)logout
{
    self.oauthToken = nil;
    [[FBSession activeSession] closeAndClearTokenInformation];
}


#pragma mark - Generic

- (void)loadFromEndPoint:(NSString*)endPoint completion:(ServiceManagerHandler)completion
{
    NSString *param = [[NSDictionary dictionaryWithObjectsAndKeys:
                        self.oauthToken, @"authentication_token",
                        nil] paramString];
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, endPoint, param];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        
        if (statusCode == 200 && data)
        {
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            
            if (!JSONError)
            {
                NSLog(@"result: %@", result);
                completion(result, YES, nil);
            }
            else
            {
                NSLog(@"JSON error: %@", JSONError);
                completion(nil, NO, JSONError);
            }
        }
        else
        {
            NSLog(@"HTTP Status %d: %@", statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            NSLog(@"URL: %@", URL);
            if (error)
            {
                NSLog(@"Error: %@", error);
            }
            completion(nil, NO, error);
        }
    }];
}


#pragma mark - Entity

- (void)loadEntityWithID:(NSString*)entityID completion:(ServiceManagerHandler)completion
{
    NSString* fullEntityInfoPath = [NSString stringWithFormat:entityInfoPath, self.currentUserID];

    [self loadFromEndPoint:fullEntityInfoPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            User* currentUser = [User currentUser];
            currentUser.name = [response objectForKey:@"name"];
            currentUser.nickname = [response objectForKey:@"nickname"];
            currentUser.imageURLString = [response objectForKey:@"image_thumb_url"];
            currentUser.userID = [response objectForKey:@"id"];
            [currentUser save];
            completion(currentUser, YES, nil);
        }
        else
        {
            completion(nil, NO, error);
        }
    }];
}


#pragma mark - Recent Photo

- (void)loadRecentPhotosWithHandler:(ServiceManagerHandler)completion
{
    [self loadFromEndPoint:recentPhotoPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [Photo objectsWithArray:response completion:^(NSArray *photos) {
                completion(photos, YES, nil);
            }];
        }
        else
        {
            completion(nil, NO, error);
        }
    }];
}

- (void)loadPopularPhotosWithHandler:(ServiceManagerHandler)completion
{
    [self loadFromEndPoint:popularPhotoPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [Photo objectsWithArray:response completion:^(NSArray *photos) {
                completion(photos, YES, nil);
            }];
        }
        else
        {
            completion(nil, NO, error);
        }
    }];
}

- (void)loadUserPhotosWithHandler:(ServiceManagerHandler)completion
{
    NSString* fullUserPhotoPath = [NSString stringWithFormat:userPhotoPath, @"1"];

    [self loadFromEndPoint:fullUserPhotoPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [Photo objectsWithArray:response completion:^(NSArray *photos) {
                completion(photos, YES, nil);
            }];
        }
        else
        {
            completion(nil, NO, error);
        }
    }];
}


#pragma mark - User Defaults

- (NSString*)oauthToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"];
}

- (void)setOauthToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"oauthToken"];
}

- (NSString*)currentUserID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserID"];
}

- (void)setCurrentUserID:(NSString*)theID
{
    [[NSUserDefaults standardUserDefaults] setObject:theID forKey:@"currentUserID"];
}

@end
