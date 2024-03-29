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
#import "Request+Spread.h"
#import "NSError+Spread.h"
#import "FacebookSDK.h"

NSString * const SpreadNotificationUploadProgressChanged  = @"SpreadNotificationUploadProgressChanged";
NSString * const SpreadNotificationUploadFinished = @"SpreadNotificationUploadFinished";

#ifdef DEV
static NSString* const baseURL =    @"http://dev.spread.cm/api/v1";
static NSString* const flagURL =    @"http://dev.spread.cm/news_photo_reports"; // This endpoint is an anomaly!

#else
static NSString* const baseURL =    @"http://www.spread.cm/api/v1";
static NSString* const flagURL =    @"http://www.spread.cm/news_photo_reports";
#endif

static NSString* const loginPath =              @"users/login.json";
static NSString* const facebookLoginPath =      @"fb_authenticate";
static NSString* const entityInfoPath =         @"entities/%@";
static NSString* const recentPhotoPath =        @"news_photos/recent.json";
static NSString* const popularPhotoPath =       @"news_photos/popular.json";
static NSString* const userPhotoPath =          @"entities/%@/news_photos.json";
static NSString* const requestsPath =           @"requests.json";
static NSString* const postUserPhotoPath =      @"news_photos";
static NSString* const postRequestPhotoPath =   @"requests/%@/request_photos";

static NSString* boundary = nil;



@interface ServiceManager ()
@end



@implementation ServiceManager


#pragma mark - Singleton

+ (ServiceManager*)sharedManager
{
    static ServiceManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ServiceManager alloc] init];
        boundary = [NSString stringWithFormat:@"----------SpReAd--BoUnDaRy--%d----------", arc4random()];
    });
    
    return _sharedManager;
}


#pragma mark - Generic

- (void)loadFromEndPoint:(NSString*)endPoint completion:(ServiceManagerHandler)completion
{
    [self loadFromEndPoint:endPoint method:@"GET" params:nil completion:completion];
}

- (void)loadFromEndPoint:(NSString*)endPoint method:(NSString *)method params:(NSDictionary *)params completion:(ServiceManagerHandler)completion
{
    if (!self.oauthToken)
    {
        DLog(@"Error! No oauth token!");
        return;
    }
    
    NSMutableDictionary *query = [@{@"authentication_token": self.oauthToken} mutableCopy];
    if (([method isEqualToString:@"GET"] || [method isEqualToString:@"DELETE"]) && params)
    {
        [query addEntriesFromDictionary:params];
    }
    
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, endPoint, [query paramString]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method;

    // This is likely a iOS SDK bug: setting HTTPBody to any request other than POST doesn't have effect.
    if (([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) && params)
    {
        request.HTTPBody = [[params paramString] dataUsingEncoding:NSUTF8StringEncoding];
        
        if ([method isEqualToString:@"PUT"])
        {
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
    }

    [self sendURLRequest:request completion:completion];
}

- (void)sendURLRequest:(NSURLRequest *)URLRequest completion:(ServiceManagerHandler)completion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:URLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        
        if ((statusCode == 200 || statusCode == 201) && data)
        {
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            
            if (!JSONError)
            {
//                DLog(@"result: %@", result);
                if (completion) completion(result, YES, nil);
            }
            else
            {
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (!data || [string isEqualToString:@"null"])
                {
                    // null response; ignore.
                }
                else
                {
                    DLog(@"JSON error: %@", JSONError);
                    if (completion) completion(nil, NO, JSONError);
                }
            }
        }
        else
        {
            DLog(@"HTTP Status %d: %@", statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            DLog(@"URL: %@", URLRequest.URL);
            if (error) {
                DLog(@"Error: %@", error);
            }
            
            if (data) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]; // error might be in json form
                if (completion) completion(result, NO, error);
            }
            else {
                if (completion) completion(nil, NO, error);
            }
        }
    }];
}


#pragma mark - Login/Logout

- (BOOL)isSessionValid
{
    if ([User currentUser])
    {
        return ( self.oauthToken != nil );
    }
    else
    {
        self.oauthToken = nil;
        self.currentUserID = nil;
        return NO;
    }
}

- (void)sendLoginRequest:(NSURLRequest*)request completion:(ServiceManagerHandler)completion
{
    [self sendURLRequest:request completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            id isNew = response[@"new_user"];
            if (![isNew boolValue])
            {
                self.oauthToken = response[@"authentication_token"];
                self.currentUserID = response[@"person_id"];
                [self loadEntityWithID:self.currentUserID completion:completion];
            }
            else
            {
                completion(response, NO, nil);
            }
        }
        else
        {
            completion(response, NO, error);
        }
    }];
}

- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(ServiceManagerHandler)completion
{
    NSURL *URL = [[NSURL URLWithString:baseURL] URLByAppendingPathComponent:loginPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSString *param = [@{@"session[email]": email,
                       @"session[password]": password} paramString];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendLoginRequest:request completion:completion];
}

- (void)loginWithFacebookToken:(NSString*)token completion:(ServiceManagerHandler)completion
{
    NSURL *URL = [[NSURL URLWithString:baseURL] URLByAppendingPathComponent:facebookLoginPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSString *param = [@{@"fb_access_token": token} paramString];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendLoginRequest:request completion:completion];
}

- (void)logout
{
    self.oauthToken = nil;
    self.currentUserID = nil;
    [[FBSession activeSession] closeAndClearTokenInformation];
}


#pragma mark - Register

- (void)registerUserWithName:(NSString *)name email:(NSString *)email nickname:(NSString *)nickname password:(NSString *)password completion:(ServiceManagerHandler)completion
{
    NSDictionary *params = @{
                             @"user[name]" : name,
                             @"user[email]" : email,
                             @"user[nickname]" : nickname,
                             @"user[password]" : password,
                             @"user[password_confirmation]" : password,
                             };
    
    NSString* URLString = [NSString stringWithFormat:@"%@/users", baseURL];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[params paramString] dataUsingEncoding:NSUTF8StringEncoding];

    [self sendURLRequest:request completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            self.oauthToken = response[@"authentication_token"];
            self.currentUserID = response[@"person_id"];
            [self loadEntityWithID:self.currentUserID completion:completion];
        }
        else
        {
            completion(response, NO, error);
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
            User* user = (User*)[User objectWithDict:response inContext:[User mainMOC]];
            [user save];
            completion(user, YES, nil);
        }
        else
        {
            completion(response, NO, error);
        }
    }];
}


#pragma mark - Recent Photo

- (void)loadRecentPhotosWithHandler:(ServiceManagerHandler)completion
{
    [self loadFromEndPoint:recentPhotoPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [Photo objectsWithArray:response inContext:[Photo mainMOC] completion:^(NSArray *photos) {
                completion(photos, YES, nil);
            }];
        }
        else
        {
            completion(response, NO, error);
        }
    }];
}

- (void)loadPopularPhotosWithHandler:(ServiceManagerHandler)completion
{
    [self loadFromEndPoint:popularPhotoPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [Photo objectsWithArray:response inContext:[Photo mainMOC] completion:^(NSArray *photos) {
                completion(photos, YES, nil);
            }];
        }
        else
        {
            completion(response, NO, error);
        }
    }];
}

- (void)loadUserPhotosWithHandler:(ServiceManagerHandler)completion
{
    NSString* fullUserPhotoPath = [NSString stringWithFormat:userPhotoPath, [[User currentUser].userID stringValue]];

    [self loadFromEndPoint:fullUserPhotoPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [Photo objectsWithArray:response inContext:[Photo mainMOC] completion:^(NSArray *photos) {
                completion(photos, YES, nil);
            }];
        }
        else
        {
            completion(response, NO, error);
        }
    }];
}


#pragma mark - Requests

- (void)loadRequestsWithHandler:(ServiceManagerHandler)completion
{
    [self loadFromEndPoint:requestsPath completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [Request objectsWithArray:response inContext:[Photo mainMOC] completion:^(NSArray *requests) {
                completion(requests, YES, nil);                
            }];
        }
        else
        {
            completion(response, NO, error);
        }
    }];
}


#pragma mark - Post Photo

- (void)sendURLRequest:(NSMutableURLRequest *)URLRequest withImageURL:(NSString *)remoteURL name:(NSString*)name csvTags:(NSString*)csvTags description:(NSString*)description completion:(ServiceManagerHandler)completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if (name)
        params[@"news_photo[name]"] = name;
    if (csvTags)
        params[@"news_photo[tags_csv]"] = csvTags;
    if (description)
        params[@"news_photo[description]"] = description;
    if (remoteURL)
        params[@"news_photo[remote_image_url]"] = remoteURL;
    
    URLRequest.HTTPBody = [[params paramString] dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendURLRequest:URLRequest completion:completion];
}

- (void)sendUploadURLRequest:(NSURLRequest *)URLRequest completionHandler:(ServiceManagerHandler)completion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    __block ConnectionHelper *helper =
    [ConnectionHelper sendAsynchronousRequest:URLRequest
                           didReceiveResponse:^(NSURLResponse *response) {
                               
                               DLog(@"NSURLResponse %@", response);
                               
                           } didSendData:^(float progress) {
                               
                               DLog(@"Upload progress: %f", progress);
                               [[NSNotificationCenter defaultCenter] postNotificationName:SpreadNotificationUploadProgressChanged object:self];
                               
                           } didWriteData:^(float progress) {
                               
                               DLog(@"Download progress: %f", progress);
                               
                           } completion:^(id data, BOOL success, NSError *error) {
                               
                               if (data)
                               {
                                   NSError* JSONError = nil;
                                   id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                   DLog(@"result: %@", result);
                                   if (completion) completion(nil, YES, nil);
                                   [self.uploadQueue removeObject:helper];
                               }
                               else
                               {
                                   DLog(@"error: %@", error);
                                   if (completion) completion(nil, NO, error);
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = self.uploadQueue.count;
                               [[NSNotificationCenter defaultCenter] postNotificationName:SpreadNotificationUploadFinished object:self];
                           }];
    
    [self.uploadQueue addObject:helper];
}


- (void)uploadImageURL:(NSString *)remoteURL name:(NSString*)name csvTags:(NSString*)csvTags description:(NSString*)description completionHandler:(ServiceManagerHandler)completion
{
    if (name.length < 4)
    {
        NSError *error = [NSError invalidPhotoTitleError];
        if (completion) completion(nil, NO, error);
        return;
    }
    
    if (description.length < 4)
    {
        NSError *error = [NSError invalidPhotoDescriptionError];
        if (completion) completion(nil, NO, error);
        return;
    }
    
    if (!remoteURL)
    {
        NSError *error = [NSError invalidImageError];
        if (completion) completion(nil, NO, error);
        return;
    }
    
    NSString *param = [@{@"authentication_token": self.oauthToken} paramString];
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, postUserPhotoPath, param];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    URLRequest.HTTPMethod = @"POST";
    
    [self sendURLRequest:URLRequest withImageURL:remoteURL name:name csvTags:csvTags description:description completion:completion];
}

- (void)uploadImageURL:(NSString *)remoteURL toRequest:(Request *)photoRequest completionHandler:(ServiceManagerHandler)completion
{
    if (!remoteURL)
    {
        NSError *error = [NSError invalidImageError];
        if (completion) completion(nil, NO, error);
        return;
    }
    
    NSString *param = [@{@"authentication_token": self.oauthToken} paramString];
    NSString *pathForRequest = [NSString stringWithFormat:postRequestPhotoPath, photoRequest.requestID];
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, pathForRequest, param];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    URLRequest.HTTPMethod = @"POST";
    
    [self sendURLRequest:URLRequest withImageURL:remoteURL name:nil csvTags:nil description:nil completion:completion];
}

- (void)updatePhoto:(Photo *)photo name:(NSString*)name csvTags:(NSString*)csvTags description:(NSString*)description completionHandler:(ServiceManagerHandler)completion
{
    NSString *endPoint = [NSString stringWithFormat:@"news_photos/%d.json", [photo.photoID integerValue]];
    
    NSString *param = [@{@"authentication_token": self.oauthToken} paramString];
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, endPoint, param];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    URLRequest.HTTPMethod = @"PUT";
    
    [self sendURLRequest:URLRequest withImageURL:nil name:name csvTags:csvTags description:description completion:^(id response, BOOL success, NSError *error) {
        
        if (success){
            
            [Photo objectWithDict:response inContext:[Photo mainMOC]];
        }
        
        completion(response, success, error);
    }];
}

- (void)deletePhoto:(Photo *)photo completionHandler:(ServiceManagerHandler)completion
{
    NSString *endPoint = [NSString stringWithFormat:@"news_photos/%d.json", [photo.photoID integerValue]];
    [[ServiceManager sharedManager] loadFromEndPoint:endPoint method:@"DELETE" params:nil completion:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [photo.managedObjectContext deleteObject:photo];
            if (completion) completion(response, YES, nil);
        }
        else
        {
            if (completion) completion(response, NO, error);
        }
    }];
}

- (void)flagPhoto:(Photo *)photo reason:(FlagReason)reason completionHandler:(ServiceManagerHandler)completion
{    
    NSString* URLString = [NSString stringWithFormat:flagURL];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSDictionary *params = @{@"authenticity_token" : self.oauthToken,
                             @"news_photo_report[news_photo_id]" : photo.photoID,
                             @"news_photo_report[reason]" : @(reason)};

    request.HTTPBody = [[params paramString] dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendURLRequest:request completion:completion];
}

- (NSMutableArray *)uploadQueue
{
    if (!_uploadQueue)
    {
        _uploadQueue = [NSMutableArray array];
    }
    return _uploadQueue;
}


#pragma mark - Support Email

- (NSString*)supportEmail
{
    static NSString* const supportEmail = @"joinspread@gmail.com";
    return supportEmail;
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
    [User clearCurrentUser];
    [[NSUserDefaults standardUserDefaults] setObject:theID forKey:@"currentUserID"];
}

@end
