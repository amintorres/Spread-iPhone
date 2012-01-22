//
//  User+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/13/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "User+Spread.h"
#import "SpreadAPIDefinition.h"


static User* currentUser = nil;


@implementation User (Spread)


+ (User*)currentUser
{
    if ( !currentUser )
    {
        //// There will always be only one user /////
        
        NSArray* allObjects = [User allObjects];        
        NSInteger index = 0;
        
        for ( User* user in allObjects )
        {
            if ( index == 0 )
            {
                currentUser = user;
            }
            else
            {
                //// Delete redundant users ////
                NSLog(@"Warning! more than one user found!");
                [[User managedObjectContext] deleteObject:user];
            }
            
            index++;
        }
        
        if ( !currentUser )
        {
            currentUser = [User object];
        }
    }
    
    return currentUser;
}

+ (void)clearUser
{
    currentUser = nil;
    
    NSArray* allObjects = [User allObjects];
    
    for ( User* user in allObjects )
    {
        [[User managedObjectContext] deleteObject:user];
    }
    
    [[User managedObjectContext] save:nil];
}

+ (NSString*)oauthToken
{
    return [[User currentUser] singleAccessToken];
}

- (NSURL*)avatarURL
{
    NSURL* avatarURL = [NSURL URLWithString:self.avatarPath];
    return avatarURL;
}


@end
