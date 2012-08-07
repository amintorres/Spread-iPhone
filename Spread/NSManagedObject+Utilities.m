//
//  NSManagedObject+Utilities.m
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSManagedObject+Utilities.h"


@implementation NSManagedObject (Utilities)


#pragma mark -

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    return [(id)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator];
}

+ (NSManagedObjectContext *)mainMOC
{
    static NSManagedObjectContext* _mainMOC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainMOC.persistentStoreCoordinator = [self persistentStoreCoordinator];
    });
    return _mainMOC;
}

+ (NSManagedObjectContext *)privateMOC
{
    static NSManagedObjectContext* _privateMOC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _privateMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateMOC.persistentStoreCoordinator = [self persistentStoreCoordinator];
    });
    return _privateMOC;
}



#pragma mark -

- (BOOL)save
{
	return [[self managedObjectContext] save:nil];
}

- (void)deleteObject
{
	[[self managedObjectContext] deleteObject:self];
}


#pragma mark -

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext*)context
{
    return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
}

+ (NSManagedObject *)objectInContext:(NSManagedObjectContext*)context
{
    __block id object = nil;
    [context performBlockAndWait:^{
        object = [NSEntityDescription insertNewObjectForEntityForName:[self entityInContext:context].name inManagedObjectContext:context];
    }];
	return object;
}

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSManagedObject* object = [self objectInContext:context];
	return object;
}

+ (void)objectsWithArray:(NSArray*)array completion:(void(^)(NSArray* photos))completion
{
    [[self privateMOC] performBlock:^{
        
        __block NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array)
        {
            id privateMO = [self objectWithDict:dict inContext:[self privateMOC]];
            NSManagedObjectID *moid = [privateMO objectID];
            
            [[self mainMOC] performBlockAndWait:^{
                id mainMO = [[self mainMOC] objectWithID:moid];
                [photos addObject:mainMO];
            }];
        }
        completion(photos);
    }];
}

//+ (NSArray *)objectsWithPredicate:(NSPredicate*)predicate sortDescriptors:(NSArray*)sortDescriptors inContext:(NSManagedObjectContext*)context
//{
//    
//}



@end
