//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Modified by Joseph Lin on 1/19/12.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"
#import "ServiceManager.h"
#import "UIAlertView+Utilities.h"


@interface PullRefreshTableViewController ()
@property (strong, nonatomic) UIAlertView* alert;
@property (nonatomic) BOOL isDragging;
@property (nonatomic) BOOL isLoading;
- (void)startLoading;
- (void)stopLoading;
@end



@implementation PullRefreshTableViewController

@synthesize tableView;
@synthesize pullRefreshHeaderView;
@synthesize isDragging, isLoading;
@synthesize alert;


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    UINib* nib = [UINib nibWithNibName:@"PullRefreshHeaderView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.pullRefreshHeaderView.pullText = @"Pull down to refresh...";
    self.pullRefreshHeaderView.releaseText = @"Release to refresh...";
    self.pullRefreshHeaderView.loadingText = @"Loading...";
    [self.view insertSubview:self.pullRefreshHeaderView belowSubview:self.tableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidLoadPhotosNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        [self.tableView reloadData];
        [self stopLoading];
    }];
}

- (void)viewDidUnload
{
    self.tableView = nil;
    self.pullRefreshHeaderView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Scroll View

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ( !self.isLoading )
    {
        self.isDragging = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( self.isLoading )
    {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
        {
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
        else if ( scrollView.contentOffset.y >= -self.pullRefreshHeaderView.bounds.size.height )
        {
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    }
    else if ( self.isDragging && scrollView.contentOffset.y < 0 )
    {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.3 animations:^(void){
            
            if (scrollView.contentOffset.y < -self.pullRefreshHeaderView.bounds.size.height)
            {
                // User is scrolling above the header
                [self.pullRefreshHeaderView setState:PullRefreshStateDragging];
            }
            else
            { 
                // User is scrolling somewhere within the header
                [self.pullRefreshHeaderView setState:PullRefreshStateIdle];
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( self.isLoading )
        return;

    isDragging = NO;
    
    if ( scrollView.contentOffset.y <= -self.pullRefreshHeaderView.bounds.size.height )
    {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading
{
    isLoading = YES;

    // Show the header
    [UIView animateWithDuration:0.3 animations:^(void){
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.pullRefreshHeaderView.bounds.size.height, 0, 0, 0);
        [self.pullRefreshHeaderView setState:PullRefreshStateLoading];
    }];

    // Refresh action!
    [self refresh];
}

- (void)stopLoading
{
    isLoading = NO;

    // Hide the header
    [UIView animateWithDuration:0.3 animations:^(void){
        
        self.tableView.contentInset = UIEdgeInsetsZero;

    } completion:^(BOOL finished){
        
        [self.pullRefreshHeaderView setState:PullRefreshStateIdle];
    }];
}

- (void)refresh
{
    [ServiceManager loadUserInfoFromServer];
    RKObjectLoader* loader = [ServiceManager loadDataFromServer];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidFailNotification object:loader queue:nil usingBlock:^(NSNotification* notification){
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SpreadDidFailNotification object:notification.object];
        [self stopLoading];
        [UIAlertView showAlertWithError:[notification.userInfo objectForKey:@"error"]];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alert = nil;
}

@end
