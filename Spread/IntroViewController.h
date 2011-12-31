//
//  IntroViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IntroViewControllerDelegate;

@interface IntroViewController : UIViewController

@property (assign, nonatomic) id <IntroViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonTapped:(id)sender;

@end



@protocol IntroViewControllerDelegate <NSObject>

- (void)introViewControllerDidLogin:(IntroViewController*)controller;

@end
