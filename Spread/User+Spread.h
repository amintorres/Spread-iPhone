//
//  User+Spread.h
//  Spread
//
//  Created by Joseph Lin on 1/13/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface User (Spread)

+ (id)currentUser;
+ (void)clearUser;
+ (NSString*)oauthToken;
- (NSURL*)avatarURL;

@end
