//
//  IntroViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "IntroViewController.h"



@implementation IntroViewController

@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)loginButtonTapped:(id)sender
{
    [delegate introViewControllerDidLogin:self];
}

@end
