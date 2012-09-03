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
#import "NSDate+Spread.h"



@implementation Photo (Spread)


+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Photo* photo = (Photo*)[super objectWithDict:dict inContext:context];
    photo.photoID = [dict objectForKey:[self jsonIDKey]];
    photo.name = [dict objectForKey:@"name"];
    photo.photoDescription = [dict objectForKey:@"description"];
    photo.impressionsCount = [dict objectForKey:@"impressions_count"];
    photo.favoritesCount = [dict objectForKey:@"favorites_count"];
    photo.commentsCount = [dict objectForKey:@"comments_count"];
    photo.createdDate = [NSDate dateFromServerString:[dict objectForKey:@"created_at"]];
    photo.updatedDate = [NSDate dateFromServerString:[dict objectForKey:@"updated_at"]];

    NSDictionary* images = [dict objectForKey:@"images"];
    photo.gridImageURLString = [[images objectForKey:@"thumb"] objectForKey:@"url"];
    photo.feedImageURLString = [[images objectForKey:@"square"] objectForKey:@"url"];
    photo.largeImageURLString = [[images objectForKey:@"web_preview"] objectForKey:@"url"];
    
    NSArray* tags = [dict objectForKey:@"tags"];
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

@end
