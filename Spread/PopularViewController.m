//
//  PopularViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/11/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "PopularViewController.h"



@interface PopularViewController ()
@end



@implementation PopularViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImageView.image = [UIImage imageNamed:@"icon-popular"];
    self.titleLabel.text = @"Popular\nPhotos";
}

- (void)reloadData
{
    [[ServiceManager sharedManager] loadPopularPhotosWithHandler:^(id response, BOOL success, NSError *error) {
        
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
