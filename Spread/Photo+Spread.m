//
//  Photo+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "Photo+Spread.h"
#import "UserDefaultHelper.h"


@implementation Photo (Spread)


- (void)storeDetailsToUserDefault
{
    [UserDefaultHelper setStoredTitle:self.title];
    [UserDefaultHelper setStoredTags:nil];
    [UserDefaultHelper setStoredDescription:self.photoDescription];
}

- (void)loadDetailsFromUserDefault
{
    self.title = [UserDefaultHelper storedTitle];
    self.photoDescription = [UserDefaultHelper storedDescription];
}

@end
