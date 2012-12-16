//
//  NSUserDefaults+Spread.h
//  Spread
//
//  Created by Joseph Lin on 12/16/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults (Spread)

@property (nonatomic) BOOL shouldStoreDetails;
@property (nonatomic, strong) NSString *storedTitle;
@property (nonatomic, strong) NSString *storedTags;
@property (nonatomic, strong) NSString *storedDescription;

@end

