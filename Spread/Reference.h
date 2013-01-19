//
//  Reference.h
//  Spread
//
//  Created by Joseph Lin on 1/19/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request;

@interface Reference : NSManagedObject

@property (nonatomic, retain) NSNumber * referenceID;
@property (nonatomic, retain) NSString * referenceURL;
@property (nonatomic, retain) Request *request;

@end
