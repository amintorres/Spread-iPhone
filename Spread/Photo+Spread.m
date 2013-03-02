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
#import "User+Spread.h"


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
    
    photo.gridImageURLString = (images[@"mobile_grid"]) ? images[@"mobile_grid"][@"url"] : images[@"thumb"][@"url"];
    photo.feedImageURLString = (images[@"mobile_feed"]) ? images[@"mobile_feed"][@"url"] : images[@"square"][@"url"];
    photo.largeImageURLString = (images[@"mobile"]) ? images[@"mobile"][@"url"] : images[@"web_preview"][@"url"];
    
    NSArray* tags = dict[@"tags"];
    for (NSDictionary* dict in tags)
    {
        Tag* tag = (Tag*)[Tag objectWithDict:dict inContext:context];
        [photo addTagsObject:tag];
    }
    
    photo.user = (User*)[User objectWithDict:dict[@"entity"] inContext:context];
    
    [photo loadFavoriteIDWithCompletionHandler:NULL];
    
	return photo;
}

- (BOOL)isFavorite
{
    BOOL isFavorite = (self.myFavoriteID) ? YES : NO;
    return isFavorite;
}

- (void)setIsFavorite:(BOOL)isFavorite
{
    [self setIsFavorite:isFavorite completionHandler:NULL];
}

- (void)setIsFavorite:(BOOL)isFavorite completionHandler:(ServiceManagerHandler)completion
{
    if (self.myFavoriteID)
    {
        NSString *endpoint = [NSString stringWithFormat:@"favorites/%d.json", [self.myFavoriteID integerValue]];
        [[ServiceManager sharedManager] loadFromEndPoint:endpoint method:@"DELETE" params:nil completion:completion];
        self.myFavoriteID = nil;
    }
    else
    {
        self.myFavoriteID = @0; // placeholder ID
        NSDictionary *params = @{@"favorable_type":@"NewsPhoto", @"favorable_id":self.photoID};
        [[ServiceManager sharedManager] loadFromEndPoint:@"favorites.json" method:@"POST" params:params completion:^(id response, BOOL success, NSError *error) {
            if (success)
            {
                self.myFavoriteID = response[@"id"];
                if (completion) completion(response, YES, nil);
            }
            else
            {
                NSLog(@"Error: %@", error);
                if (completion) completion(nil, NO, error);
            }
        }];
    }
}

- (void)loadFavoriteIDWithCompletionHandler:(ServiceManagerHandler)completion
{
    NSDictionary *params = @{@"favorable_type":@"NewsPhoto", @"favorable_id":self.photoID};
    [[ServiceManager sharedManager] loadFromEndPoint:@"favorites.json" method:@"GET" params:params completion:^(id response, BOOL success, NSError *error) {
        if (success)
        {
            [self.managedObjectContext performBlockAndWait:^{
                self.myFavoriteID = response[@"id"];
                if (completion) completion(response, YES, nil);
            }];
        }
        else if (!response)
        {
            // If the photo is not favorite, the response would be null.
            [self.managedObjectContext performBlockAndWait:^{
                self.myFavoriteID = nil;
                if (completion) completion(response, YES, nil);
            }];
        }
        else
        {
            NSLog(@"Error loading favorite ID: %@", error);
            if (completion) completion(nil, NO, error);
        }
    }];
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
    NSArray *sortedTagStrings = [sortedTags valueForKeyPath:@"@unionOfObjects.name"];
    NSString * csvTagsString = [sortedTagStrings componentsJoinedByString:@", "];
    return csvTagsString;
}

- (BOOL)isCurrentUser
{
    BOOL isCurrentUser = (self.user == [User currentUser]);
    return isCurrentUser;
}

@end
