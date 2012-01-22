//
//  WebViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/22/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "WebViewController.h"



@implementation WebViewController

@synthesize webView;
@synthesize URL;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
    self.webView = nil;
    [super viewDidUnload];
}


@end
