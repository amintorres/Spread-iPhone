//
//  MasterViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadProgressView.h"

extern NSString * const SpreadShouldLogoutNotification;
extern NSString * const SpreadShouldEditPhotoNotification;
extern NSString * const SpreadDidSelectPhotoNotification;
extern NSString * const SpreadDidDeselectPhotoNotification;



@interface MasterViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *gridListButton;
@property (strong, nonatomic) IBOutlet UIButton *popularButton;
@property (strong, nonatomic) IBOutlet UIButton *recentButton;
@property (strong, nonatomic) IBOutlet UIButton *myPhotoButton;

- (IBAction)gridListButtonTapped:(id)sender;
- (IBAction)popularButtonTapped:(id)sender;
- (IBAction)recentButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)myPhotoButtonTapped:(id)sender;
- (IBAction)aboutButtonTapped:(id)sender;

@end
