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

- (void)setImageView:(UIImageView*)imageView andButton:(UIButton*)button withPhotoAtIndex:(NSInteger)index
{
    if ( index < [photos count] )
    {
        Photo* photo = [photos objectAtIndex:index];
        NSURL* URL = [NSURL URLWithString:photo.gridImageURLString];
        [imageView setImageWithURL:URL];
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
    photos = thePhotos;

    [self setImageView:leftImageView andButton:leftButton withPhotoAtIndex:0];
    [self setImageView:middleImageView andButton:middleButton withPhotoAtIndex:1];
    [self setImageView:rightImageView andButton:rightButton withPhotoAtIndex:2];
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
