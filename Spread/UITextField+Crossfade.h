//
//  UITextField+Crossfade.h
//  Spread
//
//  Created by Joseph Lin on 1/10/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITextField (Crossfade)

- (void)crossFadeToText:(NSString*)theText duration:(NSTimeInterval)duration;
- (void)crossFadeToText:(NSString*)theText;

- (void)crossFadeToPlaceHolder:(NSString*)thePlaceHolder duration:(NSTimeInterval)duration;
- (void)crossFadeToPlaceHolder:(NSString*)thePlaceHolder;

@end