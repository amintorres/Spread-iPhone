//
//  PhotoCell.h
//  Spread
//
//  Created by Joseph Lin on 12/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"


@interface PhotoCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) Photo *photo;

@end
