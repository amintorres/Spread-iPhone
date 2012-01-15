//
//  ServiceManager.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ServiceManager.h"
#import "SpreadAPIDefinition.h"
#import "User+Spread.h"

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

- (NSArray*)allPhotos
{
    if ( !allPhotos )
    {
        NSFetchRequest* request = [Photo fetchRequest];
        NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
        
        allPhotos = [Photo objectsWithFetchRequest:request];
    }
    return allPhotos;
}


#pragma mark -
#pragma mark RestKit Setup

+ (void)setupRestKit
{
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:[SpreadAPIDefinition baseURL]];
    
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    
    // Initialize object store
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"Spread.sqlite"];
    
    
    // Setup our object mappings    
    /*!
     Mapping by entity. Here we are configuring a mapping by targetting a Core Data entity with a specific
     name. This allows us to map back Twitter user objects directly onto NSManagedObject instances --
     there is no backing model class!
     */
    RKManagedObjectMapping* photoMapping = [RKManagedObjectMapping mappingForClass:[Photo class]];
    photoMapping.primaryKeyAttribute = @"photoID";
    [photoMapping mapKeyPath:@"id" toAttribute:@"photoID"];
    [photoMapping mapKeyPath:@"camera" toAttribute:@"camera"];
    [photoMapping mapKeyPath:@"captured_at" toAttribute:@"capturedDate"];
    [photoMapping mapKeyPath:@"created_at" toAttribute:@"createdDate"];
    [photoMapping mapKeyPath:@"image.thumb.url" toAttribute:@"gridImageURLString"];
    [photoMapping mapKeyPath:@"image.url" toAttribute:@"feedImageURLString"];
//    [photoMapping mapKeyPath:@"image.url" toAttribute:@"largeImageURLString"];
    [photoMapping mapKeyPath:@"description" toAttribute:@"photoDescription"];
    [photoMapping mapKeyPath:@"title" toAttribute:@"title"];
    
    // Register our mappings with the provider
    [objectManager.mappingProvider setMapping:photoMapping forKeyPath:@"photo"];
    
    // Generate an inverse mapping for transforming Photo -> NSMutableDictionary. 
    [objectManager.mappingProvider setSerializationMapping:[photoMapping inverseMapping] forClass:[Photo class]];
    
    
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForClass:[User class]];
    userMapping.primaryKeyAttribute = @"userID";
    [userMapping mapKeyPath:@"id" toAttribute:@"userID"];
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"avatar.thumb.url" toAttribute:@"avatarPath"];
    [userMapping mapKeyPath:@"single_access_token" toAttribute:@"singleAccessToken"];
    
    // Register our mappings with the provider
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"user"];
    
    
    
    // Update date format  2011-12-19T22:33:40Z
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'HH:mm:ssZ" inTimeZone:nil];
    
    
    // Config routers
    [objectManager.router routeClass:[Photo class] toResourcePath:[SpreadAPIDefinition postPhotoPath] forMethod:RKRequestMethodPOST];
    [objectManager.router routeClass:[Photo class] toResourcePath:[SpreadAPIDefinition putPhotoPath] forMethod:RKRequestMethodPUT];
    [objectManager.router routeClass:[Photo class] toResourcePath:[SpreadAPIDefinition deletePhotoPath] forMethod:RKRequestMethodDELETE];
    
    [objectManager.router routeClass:[User class] toResourcePath:[SpreadAPIDefinition loginPath] forMethod:RKRequestMethodPOST];

    
    RKLogConfigureByName("RestKit/Network", RKLogLevelDefault);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDefault);
}



#pragma mark -
#pragma mark Login/Logout

+ (BOOL)isSessionValid
{
    NSString* storedToken = [User oauthToken];
    return ( storedToken != nil );
}

+ (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    User* user = [User currentUser];
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:user delegate:[ServiceManager sharedManager] block:^(RKObjectLoader *loader){
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[User class]];
        
        RKParams* params = [RKParams params];
        [params setValue:username forParam:@"user_session[email]"];
        [params setValue:password forParam:@"user_session[password]"];
        loader.params = params;
    }];
}

+ (void)logout
{
    [User clearUser];
    [[RKClient sharedClient].requestCache invalidateAll];
    [[RKObjectManager sharedManager].objectStore deletePersistantStore];

    [[RKClient sharedClient] get:[SpreadAPIDefinition logoutPath] delegate:nil];  
}

+ (void)requestInviteWithEmail:(NSString*)email name:(NSString*)name
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TBD" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
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
    if ([objectLoader wasSentToResourcePath:[SpreadAPIDefinition loginPath]])
    {
        NSLog(@"Did load user: %@", objects);
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidLoginNotification object:self];   
    }
    else if ( [[objects lastObject] isMemberOfClass:[Photo class]] )
    {
        NSFetchRequest* request = [Photo fetchRequest];
        NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
        
        self.allPhotos = [Photo objectsWithFetchRequest:request];
        [[NSNotificationCenter defaultCenter] postNotificationName:ServiceManagerDidLoadPhotosNotification object:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    NSString* responseString = [objectLoader.response bodyAsString];
    NSLog(@"Hit error: %@", error);
    NSLog(@"Response string: %@", responseString);
    
    if ( [[objectLoader resourcePath] isEqualToString:[SpreadAPIDefinition loginPath]] )
    {
        if ( objectLoader.response.statusCode == 422 )
        {
            if ( [objectLoader.response isJSON] )
            {
                NSError* error = nil;
                NSDictionary* JSONDict = [objectLoader.response parsedBody:&error];
                NSArray* allValues = [JSONDict allValues];
                NSString* reason = ( [allValues count] ) ? [[allValues objectAtIndex:0] objectAtIndex:0] : @"Please try again";
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:reason delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}


#pragma mark -
#pragma mark RKRequest Delegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{      
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
}


@end
