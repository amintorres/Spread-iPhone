//
//  RequestsViewController.h
//  Spread
//
//  Created by Joseph Lin on 8/4/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "BaseViewController.h"


@interface RequestsViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *totalRequestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
