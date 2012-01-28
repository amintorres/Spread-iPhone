//
//  WelcomeViewController.h
//  Spread
//
//  Created by Joseph Lin on 1/28/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WelcomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *contentViews;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;

- (IBAction)leftButtonTapped:(id)sender;
- (IBAction)rightButtonTapped:(id)sender;

@end
