//
//  SettingsViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "SettingsViewController.h"
#import "ServiceManager.h"


@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;
@end


@implementation SettingsViewController

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.logoutCell)
    {
        [[ServiceManager sharedManager] logout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
