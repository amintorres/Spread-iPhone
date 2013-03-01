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
#import "UIView+Shortcut.h"
#import "User+Spread.h"
#import "UIFont+Spread.h"

#define kTextMargin 20.0


@implementation FeedCell


- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    
    NSURL *URL = [NSURL URLWithString:photo.feedImageURLString];
    [self.largeImageView setImageWithURL:URL];
    
    self.favoriteButton.selected = [photo.isFavorite boolValue];
    
    self.nameLabel.text = photo.user.name;
    
    self.descriptionLabel.font = [UIFont appFontOfSize:self.descriptionLabel.font.pointSize];
    self.descriptionLabel.text = photo.photoDescription;
    CGFloat textHeight = [FeedCell suggestedTextHeightForPhoto:photo];    
    [self.descriptionLabel setHeight:textHeight];

    if (photo.isCurrentUser)
    {
        self.editButton.hidden = NO;
        [self.nameLabel setX:CGRectGetMaxX(self.editButton.frame) + 10];
    }
    else
    {
        self.editButton.hidden = YES;
        [self.nameLabel setX:CGRectGetMinX(self.editButton.frame)];        
    }
}

+ (CGFloat)suggestedTextHeightForPhoto:(Photo *)photo
{
    FeedCell *referenceCell = [self referenceCell];

    CGSize contrainSize = CGSizeMake(CGRectGetWidth(referenceCell.descriptionLabel.frame), MAXFLOAT);
    CGSize textSize = [photo.photoDescription sizeWithFont:referenceCell.descriptionLabel.font constrainedToSize:contrainSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat textHeight = textSize.height;
    textHeight = MAX(textHeight, CGRectGetHeight(referenceCell.commentImageView.frame));
    return textHeight;
}

+ (CGFloat)suggestedHeightForPhoto:(Photo *)photo
{
    FeedCell *referenceCell = [self referenceCell];
    CGFloat textHeight = [self suggestedTextHeightForPhoto:photo];
    CGFloat height = CGRectGetMinY(referenceCell.descriptionLabel.frame) + textHeight + kTextMargin;

//    if (photo.isCurrentUser) {
//        height += CGRectGetHeight(referenceCell.editButton.frame) + kTextMargin;
//    }
    
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
