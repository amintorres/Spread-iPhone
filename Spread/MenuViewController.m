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



@end
