//
//  ListTableViewCell.h
//  Spread
//
//  Created by Joseph Lin on 12/27/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"



@interface ListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) Photo *photo;

@end
