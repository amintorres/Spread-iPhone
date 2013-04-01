//
//  RequestDetailViewController.m
//  Spread
//
//  Created by Joseph Lin on 11/3/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "RequestDetailViewController.h"
#import "User+Spread.h"
#import "UIImageView+WebCache.h"
#import "NSNumber+Spread.h"
#import "RequestBriefViewController.h"
#import "CameraManager.h"
#import "RequestPhotosViewController.h"



@interface RequestDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *requesterImageView;
@property (strong, nonatomic) IBOutlet UILabel *requesterLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (strong, nonatomic) IBOutlet UIButton *photosButton;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@end



@implementation RequestDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.descriptionLabel.text = self.request.name;

    [self.requesterImageView setImageWithURL:[NSURL URLWithString:self.request.requester.imageURLString]];
    self.requesterLabel.text = self.request.requester.name;
    
    self.priceLabel.text = [self.request.amount currencyString];
    self.quantityLabel.text = [NSString stringWithFormat:@"%02d", [self.request.quantity integerValue]];
    self.daysLeftLabel.text = [NSString stringWithFormat:@"%02d", self.request.daysLeft];
    
    [self.photosButton setTitle:[NSString stringWithFormat:@"Photos (%d)", [self.request.photos count]] forState:UIControlStateNormal];
    
    self.submitButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([self.request.requester.userID isEqual:[User currentUser].userID])
    {
        self.submitButton.enabled = NO;
        [self.submitButton setTitle:@"Cannot submit to your own request" forState:UIControlStateNormal];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BriefSegue"])
    {
        ((RequestBriefViewController *)segue.destinationViewController).request = self.request;
    }
    else if ([segue.identifier isEqualToString:@"referenceSegue"])
    {
        ((RequestBriefViewController *)segue.destinationViewController).request = self.request;
    }
}

- (IBAction)submitButtonTapped:(id)sender
{
    [CameraManager sharedManager].request = self.request;
    [[CameraManager sharedManager] presentImagePickerInViewController:self];
}

- (IBAction)photosButtonTapped:(id)sender
{
    RequestPhotosViewController *controller = [RequestPhotosViewController new];
    controller.request = self.request;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
