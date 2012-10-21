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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.textField.bounds
//                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
//                                                         cornerRadii:CGSizeMake(6, 6)];
//    
//    // Create the shape layer and set its path
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = self.textField.bounds;
//    maskLayer.path = maskPath.CGPath;
//    
//    // Set the newly created shape layer as the mask for the image view's layer
//    self.textField.layer.mask = maskLayer;
//    self.textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.textField.layer.borderWidth = 1.0;
//}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.textField.frame, 2, 2)
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(6, 6)];
    maskPath.lineWidth = 2.0;
    
    [[UIColor colorWithWhite:0.95 alpha:1.0] setFill];
    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    
    
    [maskPath stroke];
    [maskPath fill];
}

@end
