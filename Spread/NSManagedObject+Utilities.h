//
//  NSManagedObject+Utilities.h
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObject (Utilities)

+ (NSManagedObjectContext *)mainMOC;
+ (NSManagedObjectContext *)privateMOC;

- (BOOL)save;
- (void)deleteObject;

+ (NSManagedObject *)objectInContext:(NSManagedObjectContext*)context;
+ (NSManagedObject *)objectWithID:(NSString*)requestedID inContext:(NSManagedObjectContext*)context;
+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context;
+ (void)objectsWithArray:(NSArray*)array completion:(void(^)(NSArray* photos))completion;
+ (NSUInteger)objectsCountWithPredicate:(NSPredicate*)predicate sortDescriptors:(NSArray*)sortDescriptors inContext:(NSManagedObjectContext*)context;
+ (NSArray *)allObjectsInContext:(NSManagedObjectContext*)context;
+ (NSUInteger)allObjectsCountInContext:(NSManagedObjectContext*)context;

@end
