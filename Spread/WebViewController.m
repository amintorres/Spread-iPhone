//
//  WebViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/22/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "WebViewController.h"


@interface WebViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end


@implementation WebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.title;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:self.URL];
    [self.webView loadRequest:request];
}


@end
