//
//  ServiceManager.m
//  Spread
//
//  Created by Joseph Lin on 12/21/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "ServiceManager.h"
#import "SpreadAPIDefinition.h"
#import "Photo.h"



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


#pragma mark -
#pragma mark RKObjectLoader Delegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    NSFetchRequest* request = [Photo fetchRequest];
	NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	
    self.allPhotos = [Photo objectsWithFetchRequest:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:ServiceManagerDidLoadPhotosNotification object:self];
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
