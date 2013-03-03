//
//  Permission.h
//  Spread
//
//  Created by Joseph Lin on 3/2/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Permission : NSManagedObject

@property (nonatomic, retain) NSNumber * create;
@property (nonatomic, retain) NSNumber * update;
@property (nonatomic, retain) NSNumber * downloadWeb;
@property (nonatomic, retain) NSNumber * destroy;
@property (nonatomic, retain) NSNumber * downloadPrint;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSNumber * readComments;
@property (nonatomic, retain) Photo *photo;

@end
