//
//  AppDelegate.m
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "TestFlight.h"
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Photo.h"
#import "SpreadAPIDefinition.h"
#import "UINavigationBar+Customize.h"



@implementation AppDelegate

@synthesize window;
@synthesize navigationController;


- (void)setupRestKit
{
    // Set the shared client
    [RKClient clientWithBaseURL:[SpreadAPIDefinition baseURL]];  

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
    [photoMapping mapKeyPath:@"image.url" toAttribute:@"imageURLString"];
    [photoMapping mapKeyPath:@"description" toAttribute:@"photoDescription"];
    [photoMapping mapKeyPath:@"title" toAttribute:@"title"];
    
    
    // Update date format so that we can parse Twitter dates properly
	// 2011-12-19T22:33:40Z
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'HH:mm:ssZ" inTimeZone:nil];
    
    
    // Register our mappings with the provider
    [objectManager.mappingProvider setMapping:photoMapping forKeyPath:@"photo"];
    
    // Generate an inverse mapping for transforming Photo -> NSMutableDictionary. 
    [objectManager.mappingProvider setSerializationMapping:[photoMapping inverseMapping] forClass:[Photo class]];
    
    
    [objectManager.router routeClass:[Photo class] toResourcePath:[SpreadAPIDefinition postPhotoPath] forMethod:RKRequestMethodPOST];
    [objectManager.router routeClass:[Photo class] toResourcePath:[SpreadAPIDefinition putPhotoPath] forMethod:RKRequestMethodPUT];
    [objectManager.router routeClass:[Photo class] toResourcePath:[SpreadAPIDefinition deletePhotoPath] forMethod:RKRequestMethodDELETE];
    
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelError);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupRestKit];
    
    [TestFlight takeOff:@"f319601b6e6c25b7c3f258bcdaa9e768_NTI4NDQyMDEyLTAxLTExIDEwOjU2OjEzLjE1NDkxNQ"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.navigationController.navigationBarHidden = YES;
    [navigationController.navigationBar customizeBackground];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
