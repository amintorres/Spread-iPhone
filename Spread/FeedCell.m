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

#define kBottomMargin 10.0


@implementation FeedCell


- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    
    NSURL *URL = [NSURL URLWithString:photo.feedImageURLString];
    [self.largeImageView setImageWithURL:URL];
    
    CGFloat textHeight = [FeedCell suggestedTextHeightForPhoto:photo];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, textHeight);

    self.descriptionLabel.text = photo.photoDescription;
}

+ (CGFloat)suggestedTextHeightForPhoto:(Photo *)photo
{
    FeedCell *referenceCell = [self referenceCell];
    
    CGSize contrainSize = CGSizeMake(CGRectGetWidth(referenceCell.descriptionLabel.frame), MAXFLOAT);
    CGSize textSize = [photo.photoDescription sizeWithFont:referenceCell.descriptionLabel.font constrainedToSize:contrainSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat textHeight = MAX(CGRectGetHeight(referenceCell.editButton.frame), textSize.height);
    return textHeight;
}

+ (CGFloat)suggestedHeightForPhoto:(Photo *)photo
{
    FeedCell *referenceCell = [self referenceCell];

    CGFloat textHeight = [self suggestedTextHeightForPhoto:photo];
    CGFloat height = CGRectGetMinY(referenceCell.descriptionLabel.frame) + textHeight + kBottomMargin;
    return height;
}

- (IBAction)editButtonTapped:(id)sender
{
    [self.delegate editPhoto:self.photo atFeedCell:self];
}

+ (FeedCell *)referenceCell
{
    static FeedCell *_referenceCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _referenceCell = [[[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil] objectAtIndex:0];
    });
    return _referenceCell;
}


@end
