//
//  WebViewController.h
//  Spread
//
//  Created by Joseph Lin on 1/22/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL* URL;

@end
