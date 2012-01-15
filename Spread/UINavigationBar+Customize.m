//
//  UINavigationBar+Customize.m
//  Spread
//
//  Created by Joseph Lin on 12/31/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "UINavigationBar+Customize.h"

#define kNavigationBarBackgroundImageViewTag 12345



@implementation UINavigationBar (Customize)

- (void)customizeBackground
{
    self.barStyle = UIBarStyleBlack;
    
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
    
    if ( !self.topItem.leftBarButtonItem )
    {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spread_logo_blue"]];
        self.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    }
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    
    UIView *backgroundImageView = [self viewWithTag:kNavigationBarBackgroundImageViewTag];
    if (backgroundImageView != nil)
    {
        [super sendSubviewToBack:backgroundImageView];
    }
}

- (void)sendSubviewToBack:(UIView *)view
{
    [super sendSubviewToBack:view];
    
    UIView *backgroundImageView = [self viewWithTag:kNavigationBarBackgroundImageViewTag];
    if (backgroundImageView != nil)
    {
        [super sendSubviewToBack:backgroundImageView];
    }
}

@end
