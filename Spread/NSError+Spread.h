//
//  NSError+Spread.h
//  Spread
//
//  Created by Joseph Lin on 1/26/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SpreadErrorDomain;

typedef enum{
    SpreadErrorCodeInvalidPhotoTitle = 101,
    SpreadErrorCodeInvalidPhotoDescription = 102,
    SpreadErrorCodeInvalidImage = 104,
}SpreadErrorCode;


@interface NSError (Spread)

+ (NSError*)invalidPhotoTitleError;
+ (NSError*)invalidPhotoDescriptionError;
+ (NSError*)invalidImageError;

@end
