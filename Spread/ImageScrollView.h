//
//  ImageScrollView.h
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//


#import <UIKit/UIKit.h>



@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView* imageView;

- (void)displayImage:(UIImage *)image;

@end
