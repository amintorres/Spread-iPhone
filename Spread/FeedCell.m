//
//  PhotoCell.m
//  Spread
//
//  Created by Joseph Lin on 12/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "FeedCell.h"
#import "UIImageView+WebCache.h"
#import "EditViewController.h"


@implementation FeedCell


- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    
    NSURL *URL = [NSURL URLWithString:photo.feedImageURLString];
    [self.largeImageView setImageWithURL:URL];
    
    self.descriptionLabel.text = photo.photoDescription;
}

- (CGFloat)suggestedCellHeight
{
    CGSize contrainSize = CGSizeMake(CGRectGetWidth(self.descriptionLabel.frame), MAXFLOAT);
    CGSize textSize = [self.photo.photoDescription sizeWithFont:self.descriptionLabel.font constrainedToSize:contrainSize lineBreakMode:NSLineBreakByWordWrapping];

    CGFloat height = CGRectGetMinY(self.descriptionLabel.frame) + textSize.height + 15.0;
    return height;
}

- (IBAction)editButtonTapped:(id)sender
{
    [self.delegate editPhoto:self.photo atFeedCell:self];
}


@end
