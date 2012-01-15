//
//  ReviewViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "ReviewViewController.h"
#import "EditViewController.h"


@implementation ReviewViewController

@synthesize imageView;
@synthesize mediaInfo;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Preview";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStyleDone target:self action:@selector(useButtonTapped:)];
    
    UIImage* image = [mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)useButtonTapped:(id)sender
{
    EditViewController* editViewController = [[EditViewController alloc] init];
    editViewController.mediaInfo = mediaInfo;
    editViewController.editMode = EditModeCreate;
    
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (IBAction)retakeButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
