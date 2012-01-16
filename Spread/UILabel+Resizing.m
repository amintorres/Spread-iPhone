//
//  UILabel+Resizing.m
//  Spread
//
//  Created by Joseph Lin on 10/25/11.
//  Copyright (c) 2011 Joseph Lin. All rights reserved.
//

#import "UILabel+Resizing.h"
#import "UIView+Shortcut.h"



@implementation UILabel (Resizing)

- (void)resizeToFit
{
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (void)resizeToFitHeight
{
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    [self setHeight:size.height];
}


@end
