//
//  Photo+Spread.h
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"


@interface Photo (Spread)

- (void)storeDetailsToUserDefault;
- (void)loadDetailsFromUserDefault;
- (BOOL)validate:(NSError**)error;

@end
