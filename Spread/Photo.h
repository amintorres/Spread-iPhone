//
//  Photo.h
//  Spread
//
//  Created by Joseph Lin on 1/6/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request, Tag, User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * favoritesCount;
@property (nonatomic, retain) NSString * feedImageURLString;
@property (nonatomic, retain) NSString * gridImageURLString;
@property (nonatomic, retain) NSNumber * impressionsCount;
@property (nonatomic, retain) NSString * largeImageURLString;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Request *request;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
