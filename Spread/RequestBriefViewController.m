//
//  RequestBriefViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/5/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "RequestBriefViewController.h"
#import "UIFont+Spread.h"
#import "CameraManager.h"
#import "User+Spread.h"


@interface RequestBriefViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end


@implementation RequestBriefViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.font = [UIFont appFontOfSize:self.textView.font.pointSize];
    self.textView.text = self.request.requestDescription;
    
    if ([self.request.requester.userID isEqual:[User currentUser].userID])
    {
        self.submitButton.hidden = YES;
    }
}

- (IBAction)submitButtonTapped:(id)sender
{
    [CameraManager sharedManager].request = self.request;
    [[CameraManager sharedManager] presentImagePickerInViewController:self];
}

@end
