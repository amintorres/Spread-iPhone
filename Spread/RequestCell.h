//
//  RequestCell.h
//  Spread
//
//  Created by Joseph Lin on 8/4/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request+Spread.h"


@interface RequestCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *byLabel;
@property (nonatomic, strong) IBOutlet UILabel *quantityLabel;
@property (nonatomic, strong) IBOutlet UILabel *dueDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) Request* request;

@end
