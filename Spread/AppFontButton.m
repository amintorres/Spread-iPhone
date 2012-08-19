//
//  AppFontButton.m
//  Spread
//
//  Created by Joseph Lin on 8/19/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "AppFontButton.h"
#import "UIFont+Spread.h"

@implementation AppFontButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString* fontName = self.titleLabel.font.fontName;
    CGFloat pointSize = self.titleLabel.font.pointSize;
    
    if ([fontName isEqualToString:[UIFont systemFontName]])
    {
        self.titleLabel.font = [UIFont appFontOfSize:pointSize];
    }
    else if ([fontName isEqualToString:[UIFont boldSystemFontName]])
    {
        self.titleLabel.font = [UIFont boldAppFontOfSize:pointSize];
    }
    else if ([fontName isEqualToString:[UIFont italicSystemFontName]])
    {
        self.titleLabel.font = [UIFont italicAppFontOfSize:pointSize];
    }
}

@end
