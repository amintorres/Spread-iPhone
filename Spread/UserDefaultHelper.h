//
//  UserDefaultHelper.h
//  Spread
//
//  Created by Joseph Lin on 1/12/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDefaultHelper : NSObject

+ (void)setShouldStoreDetails:(BOOL)shouldStoreDetails;
+ (BOOL)shouldStoreDetails;
+ (void)clearStoredDetails;

+ (void)setStoredTitle:(NSString*)title;
+ (NSString*)storedTitle;

+ (void)setStoredTags:(NSString*)tags;
+ (NSString*)storedTags;

+ (void)setStoredDescription:(NSString*)description;
+ (NSString*)storedDescription;

@end
