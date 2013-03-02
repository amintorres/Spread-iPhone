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

static NSString* const baseURL =                @"http://dev.spread.cm/api/v1";
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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (data)
        {
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            NSLog(@"result: %@", result);
            
            if ([result[@"success"] boolValue])
            {
                self.oauthToken = result[@"authentication_token"];
                self.currentUserID = result[@"person_id"];
                
                [self loadEntityWithID:self.currentUserID completion:completion];
            }
            else
            {
                NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:result[@"message"], NSLocalizedDescriptionKey, nil];
                NSError *spreadError = [NSError errorWithDomain:SpreadErrorDomain code:SpreadErrorCodeInvalidPhotoTitle userInfo:userInfo];
                
                NSLog(@"error: %@", spreadError);
                completion(nil, NO, spreadError);
                
            }
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


#pragma mark - Generic

- (void)loadFromEndPoint:(NSString*)endPoint completion:(ServiceManagerHandler)completion
{
    [self loadFromEndPoint:endPoint method:@"GET" params:nil completion:completion];
}

- (void)loadFromEndPoint:(NSString*)endPoint method:(NSString *)method params:(NSDictionary *)params completion:(ServiceManagerHandler)completion
{
    if (!self.oauthToken)
    {
        NSLog(@"Error! No oauth token!");
        return;
    }
    
    NSString *token = [@{@"authentication_token": self.oauthToken} paramString];
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, endPoint, token];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method;

    if (params) {
        request.HTTPBody = [[params paramString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        
        if (statusCode == 200 && data)
        {
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            
            if (!JSONError)
            {
                NSLog(@"result: %@", result);
                if (completion) completion(result, YES, nil);
            }
            else
            {
                NSLog(@"JSON error: %@", JSONError);
                if (completion) completion(nil, NO, JSONError);
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
            if (completion) completion(nil, NO, error);
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
            [Photo objectsWithArray:response inContext:[Photo mainMOC] completion:^(NSArray *photos) {
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
            [Photo objectsWithArray:response inContext:[Photo mainMOC] completion:^(NSArray *photos) {
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
            completion(nil, NO, error);
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
            completion(nil, NO, error);
        }
    }];
}


#pragma mark - Post Photo

- (void)postUserPhoto:(NSData *)imageData name:(NSString*)name csvTags:(NSString*)csvTags description:(NSString*)description completionHandler:(ServiceManagerHandler)completion
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
    
    if (!imageData)
    {
        NSError *error = [NSError invalidImageError];
        if (completion) completion(nil, NO, error);
        return;
    }
    
    NSString *param = [@{@"authentication_token": self.oauthToken} paramString];
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, postUserPhotoPath, param];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";

    
    NSString *boundary = [NSString stringWithFormat:@"----------SpReAd--BoUnDaRy--%d----------", arc4random()];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	    
    
    NSMutableData *postBody = [NSMutableData data];

    // Name
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"news_photo[name]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // CSV Tags
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"news_photo[tags_csv]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[csvTags dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Description
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"news_photo[description]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Image
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"news_photo[image]\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];    
    [postBody appendData:imageData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    

    request.HTTPBody = postBody;
    
    // 'Complete' means prepare complete and ready to upload.
    if (completion) completion(nil, YES, nil);
    [self sendPostRequest:request completionHandler:NULL];
}

- (void)postPhoto:(NSData *)imageData toRequest:(Request *)photoRequest description:(NSString *)description completionHandler:(ServiceManagerHandler)completion
{
    if (!imageData)
    {
        NSError *error = [NSError invalidImageError];
        if (completion) completion(nil, NO, error);
        return;
    }
    
    NSString *param = [@{@"authentication_token": self.oauthToken} paramString];
    NSString *pathForRequest = [NSString stringWithFormat:postRequestPhotoPath, photoRequest.requestID];
    NSString* URLString = [NSString stringWithFormat:@"%@/%@?%@", baseURL, pathForRequest, param];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    
    NSString *boundary = [NSString stringWithFormat:@"----------SpReAd--BoUnDaRy--%d----------", arc4random()];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *postBody = [NSMutableData data];
    
    // Description
//    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[@"Content-Disposition: form-data; name=\"request_photo[name]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Image
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"request_photo[image]\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:imageData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    request.HTTPBody = postBody;
    
    // 'Complete' means prepare complete and ready to upload.
    if (completion) completion(nil, YES, nil);
    [self sendPostRequest:request completionHandler:NULL];
}

- (void)sendPostRequest:(NSURLRequest *)request completionHandler:(ServiceManagerHandler)completion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    __block ConnectionHelper *helper =
    [ConnectionHelper sendAsynchronousRequest:request
                           didReceiveResponse:^(NSURLResponse *response) {
                               
                               NSLog(@"NSURLResponse %@", response);
                               
                           } didSendData:^(float progress) {
                               
                               NSLog(@"Upload progress: %f", progress);
                               [[NSNotificationCenter defaultCenter] postNotificationName:SpreadNotificationUploadProgressChanged object:self];
                               
                           } didWriteData:^(float progress) {
                               
                               NSLog(@"Download progress: %f", progress);
                               
                           } completion:^(id data, BOOL success, NSError *error) {
                               
                               if (data)
                               {
                                   NSError* JSONError = nil;
                                   id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                   NSLog(@"result: %@", result);
                                   if (completion) completion(nil, YES, nil);
                                   [self.uploadQueue removeObject:helper];
                               }
                               else
                               {
                                   NSLog(@"error: %@", error);
                                   if (completion) completion(nil, NO, error);
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = self.uploadQueue.count;
                               [[NSNotificationCenter defaultCenter] postNotificationName:SpreadNotificationUploadFinished object:self];
                           }];
    
    [self.uploadQueue addObject:helper];
}

- (void)updatePhoto:(Photo *)photo
{
    //TODO:
}

- (void)deletePhoto:(Photo *)photo
{
    //TODO:
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
