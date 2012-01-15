//
//  Photo.h
//  Spread
//
//  Created by Joseph Lin on 1/13/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSDate * capturedDate;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * largeImageURLString;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * gridImageURLString;
@property (nonatomic, retain) NSString * feedImageURLString;

@end
