//
//  Photo+Spread.h
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "NSManagedObject+Utilities.h"
#import "Photo.h"
#import "ServiceManager.h"


@interface Photo (Spread)

@property (nonatomic, strong, readonly) NSString *csvTagsString;
@property (nonatomic, readonly) BOOL isCurrentUser;
@property (nonatomic) BOOL isFavorite;

@end
