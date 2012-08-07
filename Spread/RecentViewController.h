//
//  RecentViewController.h
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "BaseViewController.h"


@interface RecentViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *totalPhotosLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
