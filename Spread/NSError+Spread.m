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

+ (NSError*)invalidPhotoDescriptionError
{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Description must be at least 4 characters long.", NSLocalizedDescriptionKey, nil];
    return [self errorWithDomain:SpreadErrorDomain code:SpreadErrorCodeInvalidPhotoDescription userInfo:userInfo];
}

+ (NSError*)invalidImageError
{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Invalid image.", NSLocalizedDescriptionKey, nil];
    return [self errorWithDomain:SpreadErrorDomain code:SpreadErrorCodeInvalidImage userInfo:userInfo];
}


@end
