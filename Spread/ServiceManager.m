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
static NSString* const loginPath = @"api/v1/user/sign_in";
static NSString* const facebookLoginPath = @"api/v1/fb_authenticate";
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

- (NSString*)oauthToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"];
}

- (void)setOauthToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"oauthToken"];
}

- (BOOL)isSessionValid
{
    return ( self.oauthToken != nil );
}

- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(ServiceManagerHandler)completion
{
    NSURL *URL = [[NSURL URLWithString:baseURL] URLByAppendingPathComponent:loginPath];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSString *param = [[NSDictionary dictionaryWithObjectsAndKeys:
                        email, @"email",
                        password, @"password",
                        nil] paramString];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      
        if (data)
        {
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            NSLog(@"result: %@", result);
            
            completion(result, YES, nil);
        }
        else
        {
            NSLog(@"error: %@", error);
            completion(nil, NO, error);
        }
    }];
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
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (data)
        {
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            NSLog(@"result: %@", result);
            
            self.oauthToken = [result objectForKey:@"authentication_token"];
            completion(result, YES, nil);
        }
        else
        {
            NSLog(@"error: %@", error);
            completion(nil, NO, error);
        }
    }];
}


#pragma mark - Recent Photo

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




@end
