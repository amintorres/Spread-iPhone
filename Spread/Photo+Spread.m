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


+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Photo* photo = (Photo*)[super objectWithDict:dict inContext:context];
    photo.photoID = [dict objectForKey:@"id"];
    photo.name = [dict objectForKey:@"name"];
    photo.photoDescription = [dict objectForKey:@"description"];
    photo.impressionsCount = [dict objectForKey:@"impressions_count"];
    photo.favoritesCount = [dict objectForKey:@"favorites_count"];
    photo.commentsCount = [dict objectForKey:@"comments_count"];
//    photo.createdDate = [dict objectForKey:@"created_at"];
//    photo.updatedDate = [dict objectForKey:@"updated_at"];

	return photo;
}
//
//
//- (void)storeDetailsToUserDefault
//{
//    [UserDefaultHelper setStoredTitle:self.title];
//    [UserDefaultHelper setStoredTags:self.csvTags];
//    [UserDefaultHelper setStoredDescription:self.photoDescription];
//}
//
//- (void)loadDetailsFromUserDefault
//{
//    self.title = [UserDefaultHelper storedTitle];
//    self.csvTags = [UserDefaultHelper storedTags];
//    self.photoDescription = [UserDefaultHelper storedDescription];
//}

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
//
//- (BOOL)validate:(NSError**)error
//{
//    if ( [self.title length] < 4 )
//    {
//        *error = [NSError invalidPhotoTitleError];
//        return NO;
//    }
//    
//    return YES;
//}


@end
