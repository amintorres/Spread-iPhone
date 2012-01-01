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
