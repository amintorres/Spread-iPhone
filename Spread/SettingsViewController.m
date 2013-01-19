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


@interface SettingsViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
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
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:@"YES" otherButtonTitles:nil];
        [sheet showInView:self.view];
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

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [[ServiceManager sharedManager] logout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Mail Composer Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
