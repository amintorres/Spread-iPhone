//
//  RequestPhotosViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/7/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "RequestPhotosViewController.h"
#import "User+Spread.h"


@interface RequestPhotosViewController ()

@end


@implementation RequestPhotosViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImageView.image = [UIImage imageNamed:@"icon-request"];
    self.titleLabel.text = self.request.name;
    
    if ([self.request.requester.userID isEqual:[User currentUser].userID])
    {
        self.submitButton.hidden = YES;
    }
}

- (void)reloadData
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    self.photos = [self.request.photos sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
