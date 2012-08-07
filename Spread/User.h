//
//  User.h
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * imageURLString;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) Photo *photos;

@end
