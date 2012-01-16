//
//  Tag+Spread.h
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"


@interface Tag (Spread)

+ (NSSet*)tagsFromCSV:(NSString*)csvString;

@end
