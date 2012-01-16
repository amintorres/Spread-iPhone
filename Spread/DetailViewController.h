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
@property (strong, nonatomic) IBOutlet ImageScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *closebutton;
@property (strong, nonatomic) Photo *photo;


- (IBAction)closeButtonTapped:(id)sender;
- (IBAction)tapHandler:(UITapGestureRecognizer*)recognizer;

@end
