//
//  TextFieldCell.m
//  Spread
//
//  Created by Joseph Lin on 10/21/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "TextFieldCell.h"
#import <QuartzCore/QuartzCore.h>


@interface TextFieldCell ()
@property (nonatomic, strong) CAShapeLayer *roundedRectLayer;
@end


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
    
    if (!self.roundedRectLayer)
    {
        self.roundedRectLayer = [CAShapeLayer layer];
        self.roundedRectLayer.frame = self.textField.bounds;
        self.roundedRectLayer.fillColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
        self.roundedRectLayer.strokeColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        [self.layer insertSublayer:self.roundedRectLayer atIndex:0];
    }
    self.roundedRectLayer.path = path.CGPath;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
