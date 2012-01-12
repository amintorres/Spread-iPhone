//
//  UILabel+Crossfade.m
//  Spread
//
//  Created by Joseph Lin on 1/10/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "UILabel+Crossfade.h"


@implementation UILabel (Crossfade)


- (void)crossFadeToText:(NSString*)theText duration:(NSTimeInterval)duration
{
    NSTimeInterval subDuration = duration / 2;
    
    [UIView animateWithDuration:subDuration animations:^(void){
        
        self.alpha = 0.0;
        
    }completion:^(BOOL finished){
        
        self.text = theText;
        
        [UIView animateWithDuration:subDuration animations:^(void){
            
            self.alpha = 1.0;
        }];
    }];
    
}

- (void)crossFadeToText:(NSString*)theText
{
    [self crossFadeToText:theText duration:0.7];
}


@end