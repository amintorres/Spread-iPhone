//
//  TextFieldCell.m
//  Spread
//
//  Created by Joseph Lin on 10/21/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "TextFieldCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation TextFieldCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *path = nil;
    CGRect backgroundRect = CGRectInset(self.bounds, 30, 0);
    
    if (self.roundedType == RoundedTypeNone)
    {
        path = [UIBezierPath bezierPathWithRect:backgroundRect];
    }
    else
    {
        if (self.roundedType == RoundedTypeTop)
        {
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(backgroundRect, 0, 1)
                                         byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                               cornerRadii:CGSizeMake(6, 6)];
            
        }
        else
        {
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(backgroundRect, 0, -1)
                                         byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                               cornerRadii:CGSizeMake(6, 6)];
        }
    }
    
   
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.textField.bounds;
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    [self.layer insertSublayer:shapeLayer atIndex:0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
