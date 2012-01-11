//
//  RoundedRectButton.m
//  Spread
//
//  Created by Joseph Lin on 1/10/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "RoundedRectButton.h"
#import <QuartzCore/QuartzCore.h>



@implementation RoundedRectButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
}

@end
