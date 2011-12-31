//
//  AboutViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/31/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AboutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;

@end
