//
//  AboutViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/31/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h> 



@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;

@end
