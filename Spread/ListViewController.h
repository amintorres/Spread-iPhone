//
//  FeedViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListTableViewCell.h"
#import "PullRefreshTableViewController.h"
#import "ServiceManager.h"


@interface ListViewController : PullRefreshTableViewController

@property (strong, nonatomic) IBOutlet ListTableViewCell *nibLoadedCell;
@property (nonatomic) PhotoType photoType;

- (void)scrollToPhoto:(Photo*)photo;
- (UIImageView*)imageViewForPhoto:(Photo*)photo;

@end
