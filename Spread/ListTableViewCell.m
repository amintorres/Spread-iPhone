//
//  ListTableViewCell.m
//  Spread
//
//  Created by Joseph Lin on 12/27/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
