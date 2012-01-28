//
//  RoundedBorderButton.h
//  Spread
//
//  Created by Joseph Lin on 1/28/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RoundedBorderButton : UIButton

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIColor* borderColor;
@property (strong, nonatomic) UIColor* borderHighlightedColor;

@end
