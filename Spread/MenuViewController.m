//
//  MenuViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/4/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "MenuViewController.h"
#import "User+Spread.h"
#import "RecentViewController.h"
#import "PopularViewController.h"
#import "UserViewController.h"
#import "CameraManager.h"



@interface MenuViewController ()
@end



@implementation MenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* name = [[User currentUser].name uppercaseString];
    if (!name) name = @"USER";
    [self.profileButton setTitle:name forState:UIControlStateNormal];
}

- (IBAction)takePhotoButtonTapped:(id)sender
{
    [[CameraManager sharedManager] presentImagePickerInViewController:self];
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
    [self showProfileViewAnimated:YES];
}

- (void)showProfileViewAnimated:(BOOL)animated
{
    UserViewController *controller = [UserViewController new];
    [self.navigationController pushViewController:controller animated:animated];
}



@end
