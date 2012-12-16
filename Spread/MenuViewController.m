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
    [self.profileButton setTitle:name forState:UIControlStateNormal];
}

- (IBAction)logout:(id)sender
{
    [[ServiceManager sharedManager] logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takePhotoButtonTapped:(id)sender
{
    [[CameraManager sharedManager] launchImagePickerInView:self];
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
    [self showProfileView];
}

- (void)showProfileView
{
    UserViewController *controller = [UserViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}



@end
