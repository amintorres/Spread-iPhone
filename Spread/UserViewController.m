//
//  UserViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/11/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "UserViewController.h"
#import "User+Spread.h"


@interface UserViewController ()
@end



@implementation UserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImageView.image = [UIImage imageNamed:@"icon-profile"];
    self.titleLabel.text = [User currentUser].name;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[ServiceManager sharedManager] loadUserPhotosWithHandler:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photos = response;
            });
        }
        else
        {
            NSString* errorMessage = error.localizedDescription;
            if (!errorMessage) {
                errorMessage = @"An unknown error has occured.";
            }
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}


@end
