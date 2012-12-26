//
//  SettingsViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "SettingsViewController.h"
#import "WebViewController.h"
#import "ServiceManager.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface SettingsViewController () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;
@end


@implementation SettingsViewController

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"aboutSegue"])
    {
        WebViewController *controller = segue.destinationViewController;
        controller.URL = [[NSBundle mainBundle] URLForResource:@"About" withExtension:@"html"];
        controller.title = @"About Spread";
    }
    else if ([segue.identifier isEqualToString:@"privacySegue"])
    {
        WebViewController *controller = segue.destinationViewController;
        controller.URL = [[NSBundle mainBundle] URLForResource:@"privacy" withExtension:@"html"];
        controller.title = @"Privacy";
    }
    else if ([segue.identifier isEqualToString:@"termsSegue"])
    {
        WebViewController *controller = segue.destinationViewController;
        controller.URL = [[NSBundle mainBundle] URLForResource:@"terms" withExtension:@"html"];
        controller.title = @"Terms";
    }
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
    else if (cell == self.emailCell)
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Contact Us :: Send us feedback"];
        [controller setToRecipients:@[[[ServiceManager sharedManager] supportEmail]]];
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

#pragma mark - Mail Composer Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
