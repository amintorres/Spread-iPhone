//
//  MasterViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "GridViewController.h"

extern NSString * const SpreadShouldLogoutNotification;
extern NSString * const SpreadShouldEditPhotoNotification;



@interface MasterViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIButton *gridListButton;
@property (strong, nonatomic) IBOutlet UIView *cameraOverlayView;

- (IBAction)gridListButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)aboutButtonTapped:(id)sender;
- (IBAction)albumButtonTapped:(id)sender;

@end
