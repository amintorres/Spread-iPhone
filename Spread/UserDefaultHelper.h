//
//  UserDefaultHelper.h
//  Spread
//
//  Created by Joseph Lin on 1/12/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDefaultHelper : NSObject

+ (void)setOauthToken:(NSString*)token;
+ (NSString*)oauthToken;

@end
