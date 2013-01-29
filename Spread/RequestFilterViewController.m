//
//  RequestFilterViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/28/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "RequestFilterViewController.h"



@interface RequestFilterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *byDateButton;
@property (weak, nonatomic) IBOutlet UIButton *byHighestPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *byLowestPriceButton;
@end



@implementation RequestFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateButtonSelections];
}

- (IBAction)buttonTapped:(id)sender
{
    if (sender == self.byDateButton) {
        self.filterType = FilterTypeDate;
    }
    else if (sender == self.byHighestPriceButton) {
        self.filterType = FilterTypeHighestPrice;
    }
    else if (sender == self.byLowestPriceButton) {
        self.filterType = FilterTypeLowestPrice;
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.delegate dismissFilterViewController:self];
}

- (void)setFilterType:(FilterType)filterType
{
    _filterType = filterType;
    [self updateButtonSelections];
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.delegate dismissFilterViewController:self];
    });
}

- (void)updateButtonSelections
{
    switch (self.filterType) {
        case FilterTypeDate:
        default:
            self.byDateButton.selected = YES;
            self.byHighestPriceButton.selected = NO;
            self.byLowestPriceButton.selected = NO;
            break;

        case FilterTypeHighestPrice:
            self.byDateButton.selected = NO;
            self.byHighestPriceButton.selected = YES;
            self.byLowestPriceButton.selected = NO;
            break;

        case FilterTypeLowestPrice:
            self.byDateButton.selected = NO;
            self.byHighestPriceButton.selected = NO;
            self.byLowestPriceButton.selected = YES;
            break;
    }
}

@end
