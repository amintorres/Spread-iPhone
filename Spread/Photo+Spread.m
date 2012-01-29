//
//  Photo+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "Photo+Spread.h"
#import "UserDefaultHelper.h"
#import "Tag+Spread.h"
#import "NSError+Spread.h"



@implementation Photo (Spread)


- (void)storeDetailsToUserDefault
{
    [UserDefaultHelper setStoredTitle:self.title];
    [UserDefaultHelper setStoredTags:self.csvTags];
    [UserDefaultHelper setStoredDescription:self.photoDescription];
}

- (void)loadDetailsFromUserDefault
{
    self.title = [UserDefaultHelper storedTitle];
    self.csvTags = [UserDefaultHelper storedTags];
    self.photoDescription = [UserDefaultHelper storedDescription];
}

- (void)setCsvTags:(NSString *)csvTags
{
    [self willChangeValueForKey:@"csvTags"];
    [self setPrimitiveValue:csvTags forKey:@"csvTags"];
    [self didChangeValueForKey:@"csvTags"];

    self.tags = [Tag tagsFromCSV:csvTags];
}

- (NSString*)csvTags
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* sortedTags = [self.tags sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray* sortedTagNames = [sortedTags valueForKeyPath:@"@unionOfObjects.name"];
    NSString* csvString = [sortedTagNames componentsJoinedByString:@", "];
    return csvString;
}

- (BOOL)validate:(NSError**)error
{
    if ( [self.title length] < 4 )
    {
        *error = [NSError invalidPhotoTitleError];
        return NO;
    }
    
    return YES;
}


@end
