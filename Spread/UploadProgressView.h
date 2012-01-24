//
//  UploadProgressView.h
//  Spread
//
//  Created by Joseph Lin on 1/24/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedRectButton.h"


@interface UploadProgressView : UIView

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet RoundedRectButton *retryButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) id object;

- (IBAction)retryButtonTapped:(id)sender;
- (void)startSending;

@end
