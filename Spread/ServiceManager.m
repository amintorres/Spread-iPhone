//
//  ServiceManager.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "ServiceManager.h"
#import "SpreadAPIDefinition.h"
#import "UserDefaultHelper.h"

NSString * const SpreadDidLoginNotification = @"SpreadDidLoginNotification";
NSString * const ServiceManagerDidLoadPhotosNotification = @"ServiceManagerDidLoadPhotosNotification";



@interface ServiceManager ()

@end



@implementation ServiceManager

@synthesize allPhotos;


+ (ServiceManager*)sharedManager
{
    static ServiceManager* sharedManager;
    
    @synchronized(self)
    {
        if (!sharedManager)
            sharedManager = [[ServiceManager alloc] init];
        
        return sharedManager;
    }
}

+ (NSArray*)allPhotos
{
    return [[self sharedManager] allPhotos];
}


#pragma mark -
#pragma mark Login/Logout

+ (BOOL)isSessionValid
{
    NSString* token = [UserDefaultHelper oauthToken];
    return ( token != nil );
}

+ (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"user_session[email]",
                            password, @"user_session[password]", nil];
    [[RKClient sharedClient] post:[SpreadAPIDefinition loginPath] params:params delegate:[ServiceManager sharedManager]];  
}  

+ (void)logout
{
    [UserDefaultHelper setOauthToken:nil];
    
    [[RKClient sharedClient] get:[SpreadAPIDefinition logoutPath] delegate:[ServiceManager sharedManager]];  
}

+ (void)requestInviteWithEmail:(NSString*)email name:(NSString*)name
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TBD" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}


#pragma mark -
#pragma mark RKRequest Delegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{  
    NSString* responseString = [response bodyAsString];

    if ([request isPOST])
    {
        if ( response.statusCode == 200 )
        {
            [UserDefaultHelper setOauthToken:responseString];
            [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidLoginNotification object:self];
        }
        else if ( response.statusCode == 422 )
        {
            if ([response isJSON])
            {
                NSError* error = nil;
                NSDictionary* JSONDict = [response parsedBody:&error];
                NSArray* allValues = [JSONDict allValues];
                NSString* reason = ( [allValues count] ) ? [[allValues objectAtIndex:0] objectAtIndex:0] : @"Please try again";
                    
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:reason delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }            
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:responseString delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }  
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}


#pragma mark -
#pragma mark Photo Data

+ (void)loadDataFromServer
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[SpreadAPIDefinition allPhotosPath] delegate:[ServiceManager sharedManager] block:^(RKObjectLoader* loader) {
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];
    }];
}

+ (void)postPhoto:(Photo*)photo imageData:(NSData*)imageData
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:photo delegate:[ServiceManager sharedManager] block:^(RKObjectLoader *loader){
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];

        RKParams* params = [RKParams params];
        [params setValue:photo.title forParam:@"photo[title]"];
        [params setValue:photo.photoDescription forParam:@"photo[description]"];
        RKParamsAttachment* attachment = [params setData:imageData MIMEType:@"image/jpeg" forParam:@"photo[image]"];
        attachment.fileName = @"image.jpg";
        loader.params = params;
    }];
}

+ (void)updatePhoto:(Photo*)photo
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager putObject:photo delegate:[ServiceManager sharedManager] block:^(RKObjectLoader *loader){
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];
        
        RKParams* params = [RKParams params];
        [params setValue:photo.photoID forParam:@"photo[id]"];
        [params setValue:photo.title forParam:@"photo[title]"];
        [params setValue:photo.photoDescription forParam:@"photo[description]"];
        loader.params = params;
    }];
}

+ (void)deletePhoto:(Photo*)photo
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager deleteObject:photo delegate:[ServiceManager sharedManager] block:^(RKObjectLoader *loader){
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];
        
        RKParams* params = [RKParams params];
        [params setValue:photo.photoID forParam:@"photo[id]"];
        loader.params = params;
    }];
}


#pragma mark -
#pragma mark RKObjectLoader Delegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    NSLog(@"didLoadObjects: %@", objects);

    NSFetchRequest* request = [Photo fetchRequest];
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    self.allPhotos = [Photo objectsWithFetchRequest:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:ServiceManagerDidLoadPhotosNotification object:self];


//    if ([objectLoader wasSentToResourcePath:[SpreadAPIDefinition allPhotosPath]])
//    {
//    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:[error localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}


@end
