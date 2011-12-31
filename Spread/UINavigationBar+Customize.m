//
//  UINavigationBar+Customize.m
//  Spread
//
//  Created by Joseph Lin on 12/31/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "UINavigationBar+Customize.h"

#define kNavigationBarBackgroundImageViewTag 12345



@implementation UINavigationBar (Customize)

- (void)customizeBackground
{
    self.tintColor = [UIColor blackColor];
    
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:kNavigationBarBackgroundImageViewTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_background"]];
            imageView.tag = kNavigationBarBackgroundImageViewTag;
            [self insertSubview:imageView atIndex:0];
        }
    }
}

@end
