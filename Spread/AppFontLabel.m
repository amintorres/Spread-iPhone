//
//  AppFontLabel.m
//  Spread
//
//  Created by Joseph Lin on 8/19/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "AppFontLabel.h"
#import "UIFont+Spread.h"


@implementation AppFontLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString* fontName = self.font.fontName;
    CGFloat pointSize = self.font.pointSize;

    if ([fontName isEqualToString:[UIFont systemFontName]])
    {
        self.font = [UIFont appFontOfSize:pointSize];
    }
    else if ([fontName isEqualToString:[UIFont boldSystemFontName]])
    {
        self.font = [UIFont boldAppFontOfSize:pointSize];
    }
    else if ([fontName isEqualToString:[UIFont italicSystemFontName]])
    {
        self.font = [UIFont italicAppFontOfSize:pointSize];
    }
}

@end
