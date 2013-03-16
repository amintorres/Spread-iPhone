//
//  ReviewViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ReviewViewController.h"
#import "RequestEditViewController.h"
#import "EditViewController.h"
#import "CameraManager.h"


@implementation ReviewViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Preview";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStyleDone target:self action:@selector(useButtonTapped:)];
    
    UIImage* image = [self.mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}

- (IBAction)useButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if ([CameraManager sharedManager].request)
    {
        RequestEditViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"RequestEditViewController"];
        controller.mediaInfo = self.mediaInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        EditViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
        controller.mediaInfo = self.mediaInfo;
        controller.editMode = EditModeCreate;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)retakeButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
