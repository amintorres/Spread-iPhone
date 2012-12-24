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

+ (void)clearCurrentUser
{
    currentUser = nil;
}

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    User* user = (User*)[super objectWithDict:dict inContext:context];
    
    user.userID = dict[[self jsonIDKey]];
    user.name = dict[@"name"];
    user.nickname = (![dict[@"nickname"] isEqual:[NSNull null]]) ? dict[@"nickname"] : nil;
    user.imageURLString = dict[@"image_thumb_url"];
    
    return user;
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
