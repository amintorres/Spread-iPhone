//
//  RecentViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "RecentViewController.h"



@interface RecentViewController ()
@end



@implementation RecentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImageView.image = [UIImage imageNamed:@"icon-recent"];
    self.titleLabel.text = @"Recent\nPhotos";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[ServiceManager sharedManager] loadRecentPhotosWithHandler:^(id response, BOOL success, NSError *error) {
        
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
