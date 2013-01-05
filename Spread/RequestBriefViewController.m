//
//  RequestBriefViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/5/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "RequestBriefViewController.h"
#import "UIFont+Spread.h"


@interface RequestBriefViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end


@implementation RequestBriefViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.font = [UIFont appFontOfSize:self.textView.font.pointSize];
    self.textView.text = self.request.requestDescription;
}

- (IBAction)submitButtonTapped:(id)sender
{
}

@end
