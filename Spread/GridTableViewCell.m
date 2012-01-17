//
//  GridTableViewCell.m
//  Spread
//
//  Created by Joseph Lin on 1/17/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "GridTableViewCell.h"
#import "UIImageView+WebCache.h"



@implementation GridTableViewCell

@synthesize imageViewLeft;
@synthesize imageViewMiddle;
@synthesize imageViewRight;
@synthesize photos;


- (void)setImageView:(UIImageView*)imageView withPhotoAtIndex:(NSInteger)index
{
    if ( index < [photos count] )
    {
        Photo* photo = [photos objectAtIndex:index];
        NSURL* URL = [NSURL URLWithString:photo.gridImageURLString];
        [imageView setImageWithURL:URL];
    }
    else
    {
        imageView.image = nil;
    }
}

- (void)setPhotos:(NSArray *)thePhotos
{
    photos = thePhotos;

    [self setImageView:imageViewLeft withPhotoAtIndex:0];
    [self setImageView:imageViewMiddle withPhotoAtIndex:1];
    [self setImageView:imageViewRight withPhotoAtIndex:2];
}



@end
