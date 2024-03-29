//
//  NSManagedObject+Utilities.m
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSManagedObject+Utilities.h"

id objectOrNil(id object)
{
    if ([object isEqual:[NSNull null]]) {
        return nil;
    }
    return object;
}


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
    __block NSEntityDescription* entity = nil;
    [context performBlockAndWait:^{
        entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    }];
    return entity;
}

+ (NSManagedObject *)objectInContext:(NSManagedObjectContext*)context
{
    __block id object = nil;
    [context performBlockAndWait:^{
        object = [NSEntityDescription insertNewObjectForEntityForName:[self entityInContext:context].name inManagedObjectContext:context];
    }];
	return object;
}

+ (NSManagedObject *)objectWithID:(id)requestedID inContext:(NSManagedObjectContext*)context
{
    NSString* modelIDKey = [self modelIDKey];
    if (modelIDKey && requestedID)
    {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@", modelIDKey, requestedID];
        NSArray* result = [self objectsWithPredicate:predicate sortDescriptors:nil inContext:context];
        if ([result count])
        {
            // Return object with the requested ID.
            return result[0];
        }
    }
    
    // If not found, return nil.
    return nil;
}

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    id requestedID = dict[[self jsonIDKey]];
    NSManagedObject* object = [self objectWithID:requestedID inContext:context];

    if (!object)
    {
        object = [self objectInContext:context];
    }

	return object;
}

+ (void)objectsWithArray:(NSArray*)array inContext:(NSManagedObjectContext*)context completion:(void(^)(NSArray* objects))completion
{
    NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateContext.parentContext = context;
    
    [privateContext performBlock:^{
        
        __block NSMutableArray *moids = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array)
        {
            id objectInPrivateContext = [self objectWithDict:dict inContext:privateContext];
            NSManagedObjectID *moid = [objectInPrivateContext objectID];
            [moids addObject:moid];
        }
        NSError *error = nil;
        [privateContext save:&error];
        
        [context performBlock:^{

            [context save:nil];

            __block NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[array count]];
            for (id moid in moids)
            {
                id object = [context objectWithID:moid];
                [objects addObject:object];
            }
            completion(objects);
        }];
    }];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate*)predicate sortDescriptors:(NSArray*)sortDescriptors inContext:(NSManagedObjectContext*)context
{
    __block NSArray* result = nil;
    [context performBlockAndWait:^{
        NSFetchRequest* request = [NSFetchRequest new];
        request.entity = [self entityInContext:context];
        request.predicate = predicate;
        request.sortDescriptors = sortDescriptors;
        NSError* error = nil;
        result = [context executeFetchRequest:request error:&error];
    }];
	return result;
}

+ (NSUInteger)objectsCountWithPredicate:(NSPredicate*)predicate sortDescriptors:(NSArray*)sortDescriptors inContext:(NSManagedObjectContext*)context
{
    __block NSUInteger count = 0;
    [context performBlockAndWait:^{
        NSFetchRequest* request = [NSFetchRequest new];
        request.entity = [self entityInContext:context];
        request.predicate = predicate;
        request.sortDescriptors = sortDescriptors;
        NSError* error = nil;
        count = [context countForFetchRequest:request error:&error];
    }];
	return count;
}

+ (NSArray *)allObjectsInContext:(NSManagedObjectContext*)context
{
    return [self objectsWithPredicate:nil sortDescriptors:nil inContext:context];
}

+ (NSUInteger)allObjectsCountInContext:(NSManagedObjectContext*)context
{
    return [self objectsCountWithPredicate:nil sortDescriptors:nil inContext:context];
}


// Subclass should override these to provide correct values.
+ (NSString *)modelIDKey
{
    return @"id";
}

+ (NSString *)jsonIDKey
{
    return @"id";
}

@end
