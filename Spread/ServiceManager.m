//
//  ServiceManager.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "ServiceManager.h"
#import "SpreadAPIDefinition.h"



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
#pragma Photo Data

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
        loader.serializationMIMEType = RKMIMETypeJSON; // We want to send this request as JSON

        RKParams* params = [RKParams params];
        [params setValue:@"test" forParam:@"title"];
        [params setValue:@"test" forParam:@"description"];
        [params setData:imageData MIMEType:@"image/jpeg" forParam:@"image"];
        loader.params = params;
    }];
    
    
//    [[RKObjectManager sharedManager] sendObject:photo delegate:[ServiceManager sharedManager] block:^(RKObjectLoader* loader) {
//        
//        loader.method = RKRequestMethodPOST;
//        loader.serializationMIMEType = RKMIMETypeJSON; // We want to send this request as JSON
//        loader.targetObject = nil;  // Map the results back onto a new object instead of self
//        // Set up a custom serialization mapping to handle this request
//        loader.serializationMapping = [RKObjectMapping serializationMappingWithBlock:^(RKObjectMapping* mapping) {
//            [mapping mapAttributes:@"password", nil];
//        }];
//    }];
}


#pragma mark -
#pragma mark RKObjectLoader Delegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    if ([objectLoader wasSentToResourcePath:[SpreadAPIDefinition allPhotosPath]])
    {
        NSFetchRequest* request = [Photo fetchRequest];
        NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
        
        self.allPhotos = [Photo objectsWithFetchRequest:request];
        [[NSNotificationCenter defaultCenter] postNotificationName:ServiceManagerDidLoadPhotosNotification object:self];
    }
    else
    {
        NSLog(@"didLoadObjects: %@", objects);
    }
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
