//
//  DetailViewController.h
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "ImageScrollView.h"


@interface DetailViewController : UIViewController <SDWebImageManagerDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet ImageScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIScrollView *infoScrollView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *divider;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *closebutton;
@property (strong, nonatomic) Photo *photo;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)infoButtonTapped:(id)sender;
- (IBAction)closeButtonTapped:(id)sender;
- (IBAction)tapHandler:(UITapGestureRecognizer*)recognizer;
- (void)loadFeedImageAndThenLargImage;
- (void)fadeInFromRect:(CGRect)rect;
- (void)fadeOutToRect:(CGRect)rect;

@end