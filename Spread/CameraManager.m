//
//  CameraManager.m
//  Spread
//
//  Created by Joseph Lin on 12/16/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "CameraManager.h"
#import "EditViewController.h"
#import "RequestEditViewController.h"
#import "ReviewViewController.h"
#import "PhotosViewController.h"


@interface CameraManager () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end


@implementation CameraManager

+ (CameraManager *)sharedManager
{
    static CameraManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[CameraManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)presentImagePickerInViewController:(UIViewController *)controller
{
    self.presentingViewController = controller;
    
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIActionSheet* action  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        [action showInView:controller.view];
    }
    else
    {
        UIActionSheet* action  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", nil];
        [action showInView:controller.view];
    }
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == actionSheet.cancelButtonIndex )
    {
        return;
    }
    
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && buttonIndex == actionSheet.firstOtherButtonIndex )
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self.presentingViewController presentViewController:imagePicker animated:YES completion:NULL];
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        if ([CameraManager sharedManager].request)
        {
            RequestEditViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"RequestEditViewController"];
            controller.mediaInfo = info;
            [picker pushViewController:controller animated:YES];
        }
        else
        {
            EditViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
            controller.mediaInfo = info;
            controller.editMode = EditModeCreate;
            [picker pushViewController:controller animated:YES];
        }
    }
    else
    {
        ReviewViewController* reviewViewController = [[ReviewViewController alloc] init];
        reviewViewController.mediaInfo = info;
        [picker pushViewController:reviewViewController animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}



@end
