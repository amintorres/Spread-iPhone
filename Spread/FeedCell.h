//
//  PhotoCell.h
//  Spread
//
//  Created by Joseph Lin on 12/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"



@protocol FeedCellDelegate;

@interface FeedCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *largeImageView;
@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong) IBOutlet UIButton *editButton;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *flagButton;
@property (nonatomic, strong) IBOutlet UIImageView *commentImageView;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) Photo *photo;
@property (nonatomic, weak) id <FeedCellDelegate> delegate;

+ (CGFloat)suggestedHeightForPhoto:(Photo *)photo;

@end


@protocol FeedCellDelegate <NSObject>
- (void)editPhoto:(Photo *)photo atFeedCell:(FeedCell *)cell;
- (void)flagPhoto:(Photo *)photo atFeedCell:(FeedCell *)cell;
@end