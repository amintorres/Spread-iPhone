//
//  Photo.h
//  Spread
//
//  Created by Joseph Lin on 2/2/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSDate * capturedDate;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * csvTags;
@property (nonatomic, retain) NSString * feedImageURLString;
@property (nonatomic, retain) NSString * gridImageURLString;
@property (nonatomic, retain) NSString * largeImageURLString;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * favoritesCount;
@property (nonatomic, retain) NSNumber * isPopular;
@property (nonatomic, retain) NSNumber * isRecent;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;
@end
