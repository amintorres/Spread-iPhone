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
NSString * const SpreadDidLoadUserInfoNotification = @"SpreadDidLoadUserInfoNotification";
NSString * const SpreadDidLoadPhotosNotification = @"SpreadDidLoadPhotosNotification";
NSString * const SpreadDidRequestInviteNotification = @"SpreadDidRequestInviteNotification";

NSString * const SpreadDidStartSendingPhotoNotification = @"SpreadDidStartSendingPhotoNotification";
NSString * const SpreadDidSendPhotoBodyDataNotification = @"SpreadDidSendPhotoBodyDataNotification";
NSString * const SpreadDidFinishSendingPhotoNotification = @"SpreadDidFinishSendingPhotoNotification";
NSString * const SpreadDidFailSendingPhotoNotification = @"SpreadDidFailSendingPhotoNotification";



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
        request.sortDescriptors = [NSArray arrayWithObject:descriptor];
        request.predicate = [NSPredicate predicateWithFormat:@"photoID != nil"];
        
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
    objectManager.objectStore.managedObjectCache = [self sharedManager];
    
    
    // Setup our object mappings    
    /*!
     Mapping by entity. Here we are configuring a mapping by targetting a Core Data entity with a specific
     name. This allows us to map back Twitter user objects directly onto NSManagedObject instances --
     there is no backing model class!
     */
    RKManagedObjectMapping* photoMapping = [RKManagedObjectMapping mappingForClass:[Photo class]];
    photoMapping.primaryKeyAttribute = @"photoID";
    photoMapping.rootKeyPath = @"photo";
    [photoMapping mapKeyPath:@"id" toAttribute:@"photoID"];
    [photoMapping mapKeyPath:@"camera" toAttribute:@"camera"];
    [photoMapping mapKeyPath:@"captured_at" toAttribute:@"capturedDate"];
    [photoMapping mapKeyPath:@"created_at" toAttribute:@"createdDate"];
    [photoMapping mapKeyPath:@"image.iphone.grid.url" toAttribute:@"gridImageURLString"];
    [photoMapping mapKeyPath:@"image.iphone.square.url" toAttribute:@"feedImageURLString"];
    [photoMapping mapKeyPath:@"image.iphone.url" toAttribute:@"largeImageURLString"];
    [photoMapping mapKeyPath:@"description" toAttribute:@"photoDescription"];
    [photoMapping mapKeyPath:@"title" toAttribute:@"title"];
    [photoMapping mapKeyPath:@"tag_list_csv" toAttribute:@"csvTags"];
    
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
    [objectManager.router routeClass:[User class] toResourcePath:[SpreadAPIDefinition userInfoPath] forMethod:RKRequestMethodGET];

    
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
        loader.objectMapping.rootKeyPath = nil;
        RKParams* params = [RKParams params];
        [params setValue:username forParam:@"user_session[email]"];
        [params setValue:password forParam:@"user_session[password]"];
        loader.params = params;
    }];
}

+ (void)loadUserInfoFromServer
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[SpreadAPIDefinition userInfoPath] delegate:[ServiceManager sharedManager] block:^(RKObjectLoader* loader) {
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[User class]];
        loader.objectMapping.rootKeyPath = @"user";
    }];
}

+ (void)logout
{
    [ServiceManager sharedManager].allPhotos = nil;
    [User clearUser];
    [[RKClient sharedClient].requestCache invalidateAll];
    [[RKObjectManager sharedManager].objectStore deletePersistantStore];

    [[RKClient sharedClient] get:[SpreadAPIDefinition logoutPath] delegate:nil];  
}

+ (void)requestInviteWithEmail:(NSString*)email name:(NSString*)name
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            email, @"ri[email]",
                            name, @"ri[name]", nil];
    [[RKClient sharedClient] post:[SpreadAPIDefinition invitePath] params:params delegate:[ServiceManager sharedManager]]; 
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
    RKObjectLoader* loader = [objectManager postObject:photo delegate:[ServiceManager sharedManager] block:^(RKObjectLoader *loader){
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];

        RKParams* params = [RKParams params];
        [params setValue:photo.title forParam:@"photo[title]"];
        [params setValue:photo.csvTags forParam:@"photo[tag_list]"];
        [params setValue:photo.photoDescription forParam:@"photo[description]"];
        RKParamsAttachment* attachment = [params setData:imageData MIMEType:@"image/jpeg" forParam:@"photo[image]"];
        attachment.fileName = @"image.jpg";
        loader.params = params;
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidStartSendingPhotoNotification object:loader];
}

+ (void)updatePhoto:(Photo*)photo
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager putObject:photo delegate:[ServiceManager sharedManager] block:^(RKObjectLoader *loader){
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];

        RKParams* params = [RKParams params];
        [params setValue:photo.photoID forParam:@"photo[id]"];
        [params setValue:photo.title forParam:@"photo[title]"];
        [params setValue:photo.csvTags forParam:@"photo[tag_list]"];
        [params setValue:photo.photoDescription forParam:@"photo[description]"];
        loader.params = params;
    }];
}

+ (void)deletePhoto:(Photo*)photo
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager deleteObject:photo delegate:[ServiceManager sharedManager] block:^(RKObjectLoader *loader){
        
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];
        loader.objectMapping.rootKeyPath = nil;

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
        if ( [objectLoader isPOST] )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidLoginNotification object:self];   
        }
    }
    else if ( [objectLoader wasSentToResourcePath:[SpreadAPIDefinition userInfoPath]] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidLoadUserInfoNotification object:self];
    }
    else if ( [objectLoader wasSentToResourcePath:[SpreadAPIDefinition allPhotosPath]] || [[objects lastObject] isMemberOfClass:[Photo class]] )    // "allPhotosPath" might return an empty array.
    {
        self.allPhotos = nil;   // This will trigger reload on the next access.
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidLoadPhotosNotification object:self];
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
    if ([request wasSentToResourcePath:[SpreadAPIDefinition invitePath]])
    {
        NSDictionary* JSONDict = [response parsedBody:nil];
        if ( [[JSONDict objectForKey:@"success"] boolValue] )
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Request Sent" message:@"Thanks! We'll send you an invite as soon as we can." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Request" message:@"Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];            
        }
    }
    else if ( [request wasSentToResourcePath:[SpreadAPIDefinition postPhotoPath]] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidFinishSendingPhotoNotification object:request];
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    if ([request wasSentToResourcePath:[SpreadAPIDefinition invitePath]])
    {
        NSLog(@"error: %@", error);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something's wrong with the network. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else if ( [request wasSentToResourcePath:[SpreadAPIDefinition postPhotoPath]] )
    {
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidFinishSendingPhotoNotification object:request userInfo:userInfo];
    }
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if ( [request wasSentToResourcePath:[SpreadAPIDefinition postPhotoPath]] )
    {
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:bytesWritten], @"bytesWritten",
                                  [NSNumber numberWithInteger:totalBytesWritten], @"totalBytesWritten",
                                  [NSNumber numberWithInteger:totalBytesExpectedToWrite], @"totalBytesExpectedToWrite",
                                  nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidSendPhotoBodyDataNotification object:request userInfo:userInfo];
    }
}


#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidRequestInviteNotification object:self];
}


#pragma mark -
#pragma mark RKManagedObjectCache Protocal

- (NSArray*)fetchRequestsForResourcePath:(NSString*)resourcePath
{
	if ( [resourcePath isEqualToString:[SpreadAPIDefinition allPhotosPath]] )
    {
		NSFetchRequest* request = [Photo fetchRequest];
		return [NSArray arrayWithObject:request];
	}
	    
	return nil;
}



@end
