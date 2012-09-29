//
//  RequestCell.m
//  Spread
//
//  Created by Joseph Lin on 8/4/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "RequestCell.h"
#import "User+Spread.h"
#import "NSDate+Spread.h"
#import "NSNumber+Spread.h"


@implementation RequestCell


- (void)setRequest:(Request *)request
{
    _request = request;
    
    self.titleLabel.text = request.name;
    self.byLabel.text = [NSString stringWithFormat:@"By: %@", request.requester.name];
    self.quantityLabel.text = [NSString stringWithFormat:@"%d image(s) needed", [request.quantity integerValue]];
    self.dueDateLabel.text = [NSString stringWithFormat:@"Due on: %@", [request.endDate dateString]];
    self.priceLabel.text = [NSString stringWithFormat:@"%d", [request.amount integerValue]];
}

@end
