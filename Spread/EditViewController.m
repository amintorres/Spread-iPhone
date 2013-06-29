//
//  EditViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/28/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "EditViewController.h"
#import "PlaceholderTextView.h"
#import "ServiceManager.h"
#import "NSUserDefaults+Spread.h"
#import "MenuViewController.h"
#import "CameraManager.h"
#import "UIFont+Spread.h"


@interface EditViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagsLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *rememberDetailsLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *tagsTextField;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UISwitch *rememberDetailsSwitch;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@end



@implementation EditViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    self.titleLabel.font = [UIFont appFontOfSize:16];
    self.tagsLabel.font = [UIFont appFontOfSize:16];
    self.descriptionLabel.font = [UIFont appFontOfSize:16];
    self.titleTextField.font = [UIFont appFontOfSize:16];
    self.tagsTextField.font = [UIFont appFontOfSize:16];
    self.descriptionTextView.font = [UIFont appFontOfSize:16];
    self.rememberDetailsLabel.font = [UIFont appFontOfSize:16];
    
    

    self.descriptionTextView.placeholder = @"Add as much detail as possible";
    
    if ( self.editMode == EditModeCreate )
    {
        self.deleteButton.hidden = YES;
        self.rememberDetailsSwitch.hidden = NO;
        self.rememberDetailsLabel.hidden = NO;

        if ([NSUserDefaults standardUserDefaults].shouldStoreDetails)
        {
            self.rememberDetailsSwitch.on = YES;
            
            self.titleTextField.text = [NSUserDefaults standardUserDefaults].storedTitle;
            self.tagsTextField.text = [NSUserDefaults standardUserDefaults].storedTags;
            self.descriptionTextView.text = [NSUserDefaults standardUserDefaults].storedDescription;
        }
        else
        {
            self.rememberDetailsSwitch.on = NO;

            self.titleTextField.text = nil;
            self.tagsTextField.text = nil;
            self.descriptionTextView.text = nil;
        }
    }
    else
    {
        self.deleteButton.hidden = NO;
        self.rememberDetailsSwitch.hidden = YES;
        self.rememberDetailsLabel.hidden = YES;

        self.titleTextField.text = self.photo.name;
        self.tagsTextField.text = self.photo.csvTagsString;
        self.descriptionTextView.text = self.photo.photoDescription;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([NSUserDefaults standardUserDefaults].shouldStoreDetails)
    {
        [NSUserDefaults standardUserDefaults].storedTitle = self.titleTextField.text;
        [NSUserDefaults standardUserDefaults].storedTags = self.tagsTextField.text;
        [NSUserDefaults standardUserDefaults].storedDescription = self.descriptionTextView.text;
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [super viewWillDisappear:animated];
}


#pragma mark - IBAction

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonTapped:(id)sender
{
    if ( self.editMode == EditModeCreate )
    {
        UIImage* image = [self.mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary* metaData = [self.mediaInfo objectForKey:UIImagePickerControllerMediaMetadata];
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        UIImagePickerController* picker = (UIImagePickerController*)self.navigationController;
        
        if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
        {
            [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:metaData completionBlock:^(NSURL* assetURL, NSError* error){
                
                [self postPhotoAtURL:assetURL];    
            }];
        }
        else
        {
            NSURL* assetURL = [self.mediaInfo objectForKey:UIImagePickerControllerReferenceURL];
            [self postPhotoAtURL:assetURL];
        }
    }
    else
    {
        [[ServiceManager sharedManager] updatePhoto:self.photo name:self.titleTextField.text csvTags:self.tagsTextField.text description:self.descriptionTextView.text completionHandler:^(id response, BOOL success, NSError *error) {
            
            if (success)
            {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
}

- (IBAction)deleteButtonTapped:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Deleting this photo"
                                message:@"Are you sure you want to delete this photo?"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Yes, Delete", nil] show];
}

- (IBAction)rememberDetailsSwitchValueChanged:(UISwitch*)sender
{
    [NSUserDefaults standardUserDefaults].shouldStoreDetails = sender.isOn;
}


#pragma mark - Post

- (void)postPhotoAtURL:(NSURL*)assetURL
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *imageRepresentation = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(imageRepresentation.size);
        NSUInteger buffered = [imageRepresentation getBytes:buffer fromOffset:0.0 length:imageRepresentation.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        
        [[ServiceManager sharedManager] uploadImageData:data name:self.titleTextField.text csvTags:self.tagsTextField.text description:self.descriptionTextView.text completionHandler:^(id response, BOOL success, NSError *error) {
            
            if (success)
            {
                [self dismiss];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
        
    } failureBlock:^(NSError *error) {
        
        DLog(@"Error loading image: %@", error);
    }];
}

- (void)dismiss
{
    if ([[CameraManager sharedManager].presentingViewController isKindOfClass:[MenuViewController class]])
    {
        [(MenuViewController*)[CameraManager sharedManager].presentingViewController showProfileViewAnimated:NO];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex != alertView.cancelButtonIndex )
    {
        [[ServiceManager sharedManager] deletePhoto:self.photo completionHandler:^(id response, BOOL success, NSError *error) {
            
            if (success)
            {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
}


#pragma mark - TableView

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Details";
//}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] )
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //// These will trigger tableview's resize animation. ////
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


@end



