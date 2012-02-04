//
//  GridTableViewCell.m
//  Spread
//
//  Created by Joseph Lin on 1/17/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "GridTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MasterViewController.h"


@implementation GridTableViewCell

@synthesize leftButton, middleButton, rightButton;
@synthesize leftImageView, middleImageView, rightImageView;
@synthesize photos;


#pragma mark -

- (void)setImageView:(UIImageView*)imageView andButton:(UIButton*)button withPhotoAtIndex:(NSInteger)index useCurrentImageAsPlaceholder:(BOOL)useCurrentImageAsPlaceholder
{
    if ( index < [photos count] )
    {
        Photo* photo = [photos objectAtIndex:index];

        UIImage* oldImage = ( useCurrentImageAsPlaceholder ) ? imageView.image : nil;
        [imageView setImageWithURL:[NSURL URLWithString:photo.gridImageURLString] placeholderImage:oldImage ];
        button.enabled = YES;
    }
    else
    {
        imageView.image = nil;
        button.enabled = NO;
    }
}

- (void)didSelectPhotoAtIndex:(NSInteger)index
{
    if ( index < [photos count] )
    {
        Photo* photo = [photos objectAtIndex:index];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:photo forKey:@"photo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidSelectPhotoNotification object:self userInfo:userInfo];
    }
}


#pragma mark -

- (void)setPhotos:(NSArray *)thePhotos
{
    BOOL isUpdate = ( [photos isEqualToArray:thePhotos] );
    photos = thePhotos;
    
    [self setImageView:leftImageView andButton:leftButton withPhotoAtIndex:0 useCurrentImageAsPlaceholder:isUpdate];
    [self setImageView:middleImageView andButton:middleButton withPhotoAtIndex:1 useCurrentImageAsPlaceholder:isUpdate];
    [self setImageView:rightImageView andButton:rightButton withPhotoAtIndex:2 useCurrentImageAsPlaceholder:isUpdate];
}

- (IBAction)leftButtonTapped:(id)sender
{
    [self didSelectPhotoAtIndex:0];
}

- (IBAction)middleButtonTapped:(id)sender
{
    [self didSelectPhotoAtIndex:1];
}

- (IBAction)rightButtonTapped:(id)sender
{
    [self didSelectPhotoAtIndex:2];
}

@end
