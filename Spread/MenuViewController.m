//
//  MenuViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/4/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "MenuViewController.h"
#import "ServiceManager.h"
#import "User+Spread.h"
#import "EditViewController.h"
#import "ReviewViewController.h"
#import "RecentViewController.h"
#import "PopularViewController.h"
#import "UserViewController.h"



@interface MenuViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end



@implementation MenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* name = [[User currentUser].name uppercaseString];
    [self.profileButton setTitle:name forState:UIControlStateNormal];
}

- (IBAction)logout:(id)sender
{
    [[ServiceManager sharedManager] logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takePhotoButtonTapped:(id)sender
{
    return; // temporarily disabled.
    
    
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIActionSheet* action  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        [action showInView:self.view];
    }
    else
    {
        UIActionSheet* action  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", nil];
        [action showInView:self.view];
    }
}

- (IBAction)recentButtonTapped:(id)sender
{
    RecentViewController *controller = [RecentViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)popularButtonTapped:(id)sender
{
    PopularViewController *controller = [PopularViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)profileButtonTapped:(id)sender
{
    UserViewController *controller = [UserViewController new];
    [self.navigationController pushViewController:controller animated:YES];
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
    [self presentModalViewController:imagePicker animated:YES];
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
    {
        EditViewController* editViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"EditViewController"];
        editViewController.mediaInfo = info;
        editViewController.editMode = EditModeCreate;
        [picker pushViewController:editViewController animated:YES];
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
    [self dismissModalViewControllerAnimated:YES];
}



@end
