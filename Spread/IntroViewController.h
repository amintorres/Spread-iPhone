//
//  IntroViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedRectButton.h"


@interface IntroViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIButton *logoButton;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet RoundedRectButton *facebookLoginButton;
@property (strong, nonatomic) IBOutlet RoundedRectButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;
@property (strong, nonatomic) IBOutlet RoundedRectButton *registerButton;

- (IBAction)logoButtonTapped:(id)sender;
- (IBAction)loginButtonTapped:(id)sender;

@end
