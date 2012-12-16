//
//  Photo+Spread.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "Photo+Spread.h"
#import "Tag+Spread.h"
#import "NSDate+Spread.h"



@implementation Photo (Spread)


+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Photo* photo = (Photo*)[super objectWithDict:dict inContext:context];
    photo.photoID = dict[[self jsonIDKey]];
    photo.name = dict[@"name"];
    photo.photoDescription = dict[@"description"];
    photo.impressionsCount = dict[@"impressions_count"];
    photo.favoritesCount = dict[@"favorites_count"];
    photo.commentsCount = dict[@"comments_count"];
    photo.createdDate = [NSDate dateFromServerString:dict[@"created_at"]];
    photo.updatedDate = [NSDate dateFromServerString:dict[@"updated_at"]];

    NSDictionary* images = dict[@"images"];
    photo.gridImageURLString = images[@"thumb"][@"url"];
    photo.feedImageURLString = images[@"square"][@"url"];
    photo.largeImageURLString = images[@"web_preview"][@"url"];
    
    NSArray* tags = dict[@"tags"];
    for (NSDictionary* dict in tags)
    {
        Tag* tag = (Tag*)[Tag objectWithDict:dict inContext:context];
        [photo addTagsObject:tag];
    }
    
	return photo;
}

+ (NSString *)modelIDKey
{
    return @"photoID";
}

+ (NSString *)jsonIDKey
{
    return @"id";
}

- (NSString *)csvTagsString
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedTags = [self.tags sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSString * csvTagsString = [sortedTags componentsJoinedByString:@", "];
    return csvTagsString;
}

@end
