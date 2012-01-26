//
//  NSError+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/26/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "NSError+Spread.h"

NSString * const SpreadErrorDomain = @"SpreadErrorDomain";



@implementation NSError (Spread)


+ (NSError*)invalidPhotoTitleError
{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Title must be at least 4 characters long.", NSLocalizedDescriptionKey, nil];
    return [self errorWithDomain:SpreadErrorDomain code:SpreadErrorCodeInvalidPhotoTitle userInfo:userInfo];    
}


@end
