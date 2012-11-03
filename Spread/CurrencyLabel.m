//
//  CurrencyLabel.m
//  Spread
//
//  Created by Joseph Lin on 11/3/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "CurrencyLabel.h"
#import "NSNumber+Spread.h"
#import <CoreText/CTStringAttributes.h>


@implementation CurrencyLabel


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setText:(NSString *)text
{
    if ([text length])
    {
        if ([[text substringToIndex:1] isEqualToString:[NSNumber currencyFormatter].currencySymbol])
        {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                                 attributes:@{NSFontAttributeName:self.font}];
            [attributedString setAttributes:@{
             (id)kCTSuperscriptAttributeName:@1,
                        NSFontAttributeName:[UIFont fontWithName:self.font.fontName size:self.font.pointSize * 0.5]}
                                      range:NSMakeRange(0, 1)];
            [super setAttributedText:attributedString];
            return;
        }
    }
    
    [super setText:text];
}


@end
