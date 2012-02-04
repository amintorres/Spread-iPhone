//
//  ToggleButton.m
//  Spread
//
//  Created by Joseph Lin on 2/3/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "ToggleButton.h"


@implementation ToggleButton


- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
    
    self.selected = !self.selected;
}


@end
