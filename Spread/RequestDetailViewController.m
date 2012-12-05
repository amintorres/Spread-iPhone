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



@interface RequestDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *requesterImageView;
@property (strong, nonatomic) IBOutlet UILabel *requesterLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *photosLabel;
@end



@implementation RequestDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.descriptionLabel.text = self.request.requestDescription;

    [self.requesterImageView setImageWithURL:[NSURL URLWithString:self.request.requester.imageURLString]];
    self.requesterLabel.text = self.request.requester.name;
    
    self.priceLabel.text = [self.request.amount currencyString];
    self.quantityLabel.text = [NSString stringWithFormat:@"%02d", [self.request.quantity integerValue]];
    self.daysLeftLabel.text = [NSString stringWithFormat:@"%02d", self.request.daysLeft];
    
    self.photosLabel.text = [NSString stringWithFormat:@"Photos (%d)", [self.request.quantity integerValue] - [self.request.remaining integerValue]];
}



@end