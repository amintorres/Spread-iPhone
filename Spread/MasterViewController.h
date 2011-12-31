//
//  MasterViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
#import "ListViewController.h"
#import "GridViewController.h"



@interface MasterViewController : UIViewController <IntroViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIButton *gridListButton;

- (IBAction)gridListButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)aboutButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;

@end
