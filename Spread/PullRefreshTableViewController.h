//
//  PullRefreshTableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Modified by Joseph Lin on 1/19/12.
//

#import <UIKit/UIKit.h>
#import "PullRefreshHeaderView.h"


@interface PullRefreshTableViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet PullRefreshHeaderView *pullRefreshHeaderView;

- (void)refresh;

@end
