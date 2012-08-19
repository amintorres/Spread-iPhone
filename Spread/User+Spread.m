//
//  User+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/13/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "User+Spread.h"
#import "ServiceManager.h"


static User* currentUser = nil;


@implementation User (Spread)


+ (User*)currentUser
{
    if (!currentUser)
    {
        id currentUserID = [[ServiceManager sharedManager] currentUserID];
        currentUser = (User*)[User objectWithID:currentUserID inContext:[User mainMOC]];
        
        if (!currentUser)
        {
            currentUser = (User*)[User objectInContext:[User mainMOC]];
            currentUser.userID = currentUserID;
        }
    }
    return currentUser;
}


#pragma mark - 

+ (NSString *)modelIDKey
{
    return @"userID";
}

+ (NSString *)jsonIDKey
{
    return @"id";
}

@end
