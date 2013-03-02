//
//  FlagCell.m
//  Spread
//
//  Created by Joseph Lin on 3/2/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "FlagCell.h"
#import "UIFont+Spread.h"


@implementation FlagCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.checkmarkImageView.highlighted = selected;
}

@end
