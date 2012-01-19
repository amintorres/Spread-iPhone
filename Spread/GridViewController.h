//
//  GridViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridTableViewCell.h"
#import "PullRefreshTableViewController.h"


@interface GridViewController : PullRefreshTableViewController

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfPhotosLabel;
@property (strong, nonatomic) IBOutlet GridTableViewCell *nibLoadedCell;

@end
