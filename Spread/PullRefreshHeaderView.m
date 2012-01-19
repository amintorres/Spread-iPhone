//
//  PullRefreshHeaderView.m
//  Spread
//
//  Created by Joseph Lin on 1/19/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "PullRefreshHeaderView.h"


@implementation PullRefreshHeaderView

@synthesize textLabel;
@synthesize activityIndicator;
@synthesize pullText, releaseText, loadingText;


- (void)setState:(PullRefreshState)state
{
    switch (state)
    {
        case PullRefreshStateIdle:
            self.textLabel.text = self.pullText;
            [self.activityIndicator stopAnimating];
            break;
            
        case PullRefreshStateDragging:
            self.textLabel.text = self.releaseText;
            [self.activityIndicator stopAnimating];
            break;

        case PullRefreshStateLoading:
        default:
            self.textLabel.text = self.loadingText;
            [self.activityIndicator startAnimating];
            break;
    }
}

@end
