//
//  IntroTableViewController.h
//  Spread
//
//  Created by Joseph Lin on 10/21/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IntroTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIButton *logoButton;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;

- (IBAction)goBack:(id)sender;
- (IBAction)facebookLoginButtonTapped:(id)sender;
- (IBAction)loginButtonTapped:(id)sender;

@end
