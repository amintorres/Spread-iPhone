//
//  PhotosViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceManager.h"


@interface PhotosViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfPhotosLabel;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSArray *photos;

- (void)reloadData;

@end
