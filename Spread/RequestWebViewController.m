//
//  RequestWebViewController.m
//  Spread
//
//  Created by Joseph Lin on 6/29/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "RequestWebViewController.h"


@interface RequestWebViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end


@implementation RequestWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.URLString) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
        [self.webView loadRequest:request];
    }
}

@end
