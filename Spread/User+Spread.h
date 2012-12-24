//
//  User+Spread.h
//  Spread
//
//  Created by Joseph Lin on 1/13/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "NSManagedObject+Utilities.h"
#import "User.h"


@interface User (Spread)

+ (User*)currentUser;
+ (void)clearCurrentUser;

@end
