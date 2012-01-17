//
//  UIView+Shortcut.h
//  Spread
//
//  Created by Joseph Lin on 1/10/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (Shortcut)

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

CGRect CGRectConvertBetweenOrientations(CGRect frameInWindow, UIInterfaceOrientation fromOrientation, UIInterfaceOrientation toOrientation);

@end
