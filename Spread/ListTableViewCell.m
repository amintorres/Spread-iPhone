//
//  ListTableViewCell.m
//  Spread
//
//  Created by Joseph Lin on 12/27/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MasterViewController.h"


@implementation ListTableViewCell

@synthesize imageView, titleLabel, descriptionLabel, editButton;
@synthesize photo;


- (void)setPhoto:(Photo *)aPhoto
{
    if ( photo == aPhoto )
    {
        //// Triggers by update. Use currently displaying image as placeholder to avoid flicker. ////
        UIImage* oldImage = imageView.image;
        [imageView setImageWithURL:[NSURL URLWithString:photo.feedImageURLString] placeholderImage:oldImage];
    }
    else
    {
        //// Triggers by scroll. Set placeholder to nil to clear image view first. ////
        photo = aPhoto;
        [imageView setImageWithURL:[NSURL URLWithString:photo.feedImageURLString]];
    }
    
    titleLabel.text = photo.title;
    descriptionLabel.text = photo.photoDescription;
}


- (IBAction)editButtonTapped:(id)sender
{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:photo forKey:@"photo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SpreadShouldEditPhotoNotification object:self userInfo:userInfo];
}

@end
