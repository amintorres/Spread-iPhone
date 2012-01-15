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

@synthesize imageView, titleLabel, descriptionLabel;
@synthesize photo;


- (void)setPhoto:(Photo *)aPhoto
{
    photo = aPhoto;
    
    titleLabel.text = photo.title;
    descriptionLabel.text = photo.photoDescription;
    
    [imageView setImageWithURL:[NSURL URLWithString:photo.feedImageURLString]];
}


- (IBAction)editButtonTapped:(id)sender
{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:photo forKey:@"photo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SpreadShouldEditPhotoNotification object:self userInfo:userInfo];
}

@end
