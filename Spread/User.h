//
//  User.h
//  Spread
//
//  Created by Joseph Lin on 1/13/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarPath;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * singleAccessToken;

@end
