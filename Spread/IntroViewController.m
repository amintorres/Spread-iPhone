//
//  IntroViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "IntroViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation IntroViewController

@synthesize delegate;
@synthesize loginButton;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 3.0;
}

- (void)viewDidUnload
{
    self.loginButton = nil;
    [super viewDidUnload];
}

- (IBAction)loginButtonTapped:(id)sender
{
    [delegate introViewControllerDidLogin:self];
}

@end
