//
//  PullRefreshHeaderView.h
//  Spread
//
//  Created by Joseph Lin on 1/19/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    PullRefreshStateIdle = 0,
    PullRefreshStateDragging,
    PullRefreshStateLoading,
}PullRefreshState;


@interface PullRefreshHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString *pullText;
@property (strong, nonatomic) NSString *releaseText;
@property (strong, nonatomic) NSString *loadingText;

- (void)setState:(PullRefreshState)state;

@end
