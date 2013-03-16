//
//  RequestEditViewController.m
//  Spread
//
//  Created by Joseph Lin on 3/16/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "RequestEditViewController.h"
#import "PlaceholderTextView.h"
#import "ServiceManager.h"
#import "NSUserDefaults+Spread.h"
#import "MenuViewController.h"
#import "CameraManager.h"
#import "UploadViewController.h"


@interface RequestEditViewController () <UploadViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UIView *uploadContainer;
@property (nonatomic, strong) UploadViewController *uploadViewController;
@end


@implementation RequestEditViewController 

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.imageView.image = [self.mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
    
    self.uploadViewController = [UploadViewController new];
    self.uploadViewController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [CameraManager sharedManager].request = nil; // Don't forget to clear the request payload.
    
    [super viewWillDisappear:animated];
}


#pragma mark - IBAction

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonTapped:(id)sender
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


#pragma mark - Post

- (void)postPhotoAtURL:(NSURL*)assetURL
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *imageRepresentation = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(imageRepresentation.size);
        NSUInteger buffered = [imageRepresentation getBytes:buffer fromOffset:0.0 length:imageRepresentation.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        
        [[ServiceManager sharedManager] uploadImageData:data toRequest:[CameraManager sharedManager].request completionHandler:^(id response, BOOL success, NSError *error) {
            
            if (success)
            {
                [self.uploadViewController update];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"Error loading image: %@", error);
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


#pragma mark - Upload View Controller

- (void)shouldShowUploadViewController:(UploadViewController *)controller
{
    if (!self.uploadViewController.view.superview)
    {
        self.uploadViewController.view.frame = self.uploadContainer.bounds;
        [self.uploadContainer addSubview:self.uploadViewController.view];
        self.uploadViewController.view.alpha = 1.0;
    }
}

- (void)shouldHideUploadViewController:(UploadViewController *)controller
{
    [self dismiss];
}

@end
