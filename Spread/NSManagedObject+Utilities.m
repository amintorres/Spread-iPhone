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
        _privateMOC.parentContext = [self mainMOC];
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
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%@ == %@", modelIDKey, requestedID];
        NSArray* result = [self objectsWithPredicate:predicate sortDescriptors:nil inContext:context];
        if ([result count])
        {
            // Return object with the requested ID.
            return [result objectAtIndex:0];
        }
    }
    
    // If not found, return nil.
    return nil;
}

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    id requestedID = [dict objectForKey:[self jsonIDKey]];
    NSManagedObject* object = [self objectWithID:requestedID inContext:context];

    if (!object)
    {
        object = [self objectInContext:context];
    }

	return object;
}

+ (void)objectsWithArray:(NSArray*)array completion:(void(^)(NSArray* photos))completion
{
    [[self privateMOC] performBlock:^{
        
        __block NSMutableArray *moids = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array)
        {
            id privateMO = [self objectWithDict:dict inContext:[self privateMOC]];
            NSManagedObjectID *moid = [privateMO objectID];
            [moids addObject:moid];
        }
        [[self privateMOC] save:nil];
        
        [[self mainMOC] performBlock:^{

            [[self mainMOC] save:nil];

            __block NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[array count]];
            for (id moid in moids)
            {
                id mainMO = [[self mainMOC] objectWithID:moid];
                [photos addObject:mainMO];
            }
            completion(photos);
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