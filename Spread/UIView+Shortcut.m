//
//  UIView+Shortcut.m
//  Spread
//
//  Created by Joseph Lin on 1/10/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "UIView+Shortcut.h"


@implementation UIView (Shortcut)


- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

CGRect CGRectConvertBetweenOrientations(CGRect frameInWindow, UIInterfaceOrientation fromOrientation, UIInterfaceOrientation toOrientation)
{
    if ( fromOrientation == toOrientation )
        return frameInWindow;
    
    
    
    BOOL isClockwise = 
    ( fromOrientation == UIInterfaceOrientationPortrait && toOrientation == UIInterfaceOrientationLandscapeLeft ) ||
    ( fromOrientation == UIInterfaceOrientationLandscapeLeft && toOrientation == UIInterfaceOrientationPortraitUpsideDown ) ||
    ( fromOrientation == UIInterfaceOrientationPortraitUpsideDown && toOrientation == UIInterfaceOrientationLandscapeRight ) ||
    ( fromOrientation == UIInterfaceOrientationLandscapeRight && toOrientation == UIInterfaceOrientationPortrait );
    
    UIWindow* targetWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect windowRect = UIInterfaceOrientationIsPortrait(fromOrientation) ? targetWindow.bounds : CGRectMake(0, 0, targetWindow.bounds.size.height, targetWindow.bounds.size.width);
    
    if ( isClockwise )
    {
        CGFloat x = windowRect.size.height - (frameInWindow.origin.y + frameInWindow.size.height);
        CGFloat y = frameInWindow.origin.x;
        CGFloat width = frameInWindow.size.height;
        CGFloat height = frameInWindow.size.width;
        return CGRectMake(x, y, width, height);
    }
    else
    {
        CGFloat x = frameInWindow.origin.y;
        CGFloat y = windowRect.size.width - (frameInWindow.origin.x + frameInWindow.size.width);
        CGFloat width = frameInWindow.size.height;
        CGFloat height = frameInWindow.size.width;
        return CGRectMake(x, y, width, height);
    }
}



@end




