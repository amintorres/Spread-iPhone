//
//  FlagViewController.m
//  Spread
//
//  Created by Joseph Lin on 3/2/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "FlagViewController.h"
#import "ServiceManager.h"


@interface FlagViewController ()

@end


@implementation FlagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonTapped:(id)sender
{
    FlagReason reason = [self.tableView indexPathForSelectedRow].row;
    [[ServiceManager sharedManager] flagPhoto:self.photo reason:reason completionHandler:^(id response, BOOL success, NSError *error) {
       
        [[[UIAlertView alloc] initWithTitle:@"Thanks" message:@"We will review this report and take the appropriate next step." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"");
}

@end
