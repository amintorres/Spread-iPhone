//
//  UITextField+Crossfade.m
//  Spread
//
//  Created by Joseph Lin on 1/10/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "UITextField+Crossfade.h"


@implementation UITextField (Crossfade)


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


- (void)crossFadeToPlaceHolder:(NSString*)thePlaceHolder duration:(NSTimeInterval)duration
{
    NSTimeInterval subDuration = duration / 2;
    
    [UIView animateWithDuration:subDuration animations:^(void){
        
        self.alpha = 0.0;
        
    }completion:^(BOOL finished){
        
        self.placeholder = thePlaceHolder;
        
        [UIView animateWithDuration:subDuration animations:^(void){
            
            self.alpha = 1.0;
        }];
    }];
}

- (void)crossFadeToPlaceHolder:(NSString*)thePlaceHolder
{
    [self crossFadeToPlaceHolder:thePlaceHolder duration:0.7];
}



@end
