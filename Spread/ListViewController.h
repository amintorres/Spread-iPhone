//
//  FeedViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListTableViewCell.h"



@interface ListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ListTableViewCell *nibLoadedCell;

- (void)scrollToPhoto:(Photo*)photo;
- (UIImageView*)imageViewForPhoto:(Photo*)photo;

@end
