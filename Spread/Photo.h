//
//  Photo.h
//  Spread
//
//  Created by Joseph Lin on 12/19/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * capturedDate;
@property (nonatomic, retain) NSString * imageURLString;
@property (nonatomic, retain) NSString * title;

@end
