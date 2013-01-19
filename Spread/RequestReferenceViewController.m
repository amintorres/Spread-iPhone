//
//  RequestReferenceViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/19/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "RequestReferenceViewController.h"
#import "UIFont+Spread.h"
#import "CameraManager.h"


@interface RequestReferenceViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end


@implementation RequestReferenceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.font = [UIFont appFontOfSize:self.textView.font.pointSize];
    
    NSArray *URLs = [self.request.sortedReferences valueForKeyPath:@"@unionOfObjects.referenceURL"];
    self.textView.text = [URLs componentsJoinedByString:@"\n"];
}

- (IBAction)submitButtonTapped:(id)sender
{
    [CameraManager sharedManager].request = self.request;
    [[CameraManager sharedManager] presentImagePickerInViewController:self];
}

@end
