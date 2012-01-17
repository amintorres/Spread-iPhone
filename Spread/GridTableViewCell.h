//
//  GridTableViewCell.h
//  Spread
//
//  Created by Joseph Lin on 1/17/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"


@interface GridTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewMiddle;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewRight;
@property (strong, nonatomic) NSArray* photos;

@end
