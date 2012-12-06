//
//  UIImage+Utilities.m
//  Spread
//
//  Created by Joseph Lin on 12/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "UIImage+Utilities.h"


@implementation UIImage (Utilities)

- (UIImage *)normalize
{
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         self.size.width,
                                                         self.size.height,
                                                         8, (4 * self.size.width),
                                                         genericColorSpace,
                                                         kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, self.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    
    return result;
}

@end
