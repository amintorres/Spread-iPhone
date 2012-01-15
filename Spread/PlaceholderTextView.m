//
//  PlaceholderTextView.m
//  UI Element
//
//  Created by Joseph Lin on 10/24/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "PlaceholderTextView.h"
#import <QuartzCore/QuartzCore.h>



@interface PlaceholderTextView ()
@property (nonatomic) BOOL showPlaceholder;
- (void)updatePlaceholder;
@end



@implementation PlaceholderTextView

@synthesize placeholder;
@synthesize placeholderColor;
@synthesize showPlaceholder;



- (void)addObserver
{
	[[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:self queue:nil usingBlock:^(NSNotification* notification){
       
        [self updatePlaceholder];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updatePlaceholder
{
	BOOL didShowPlaceholder = self.showPlaceholder;
	self.showPlaceholder = ( self.placeholder && ![self hasText] );
    
	if ( self.showPlaceholder != didShowPlaceholder )
    {
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
    
	if (self.showPlaceholder)
    {
		[self.placeholderColor set];
		[self.placeholder drawInRect:CGRectInset(self.bounds, 8.0, 8.0) withFont:self.font];
	}
}


#pragma mark -
#pragma mark Setter/Accessor

- (void)setText:(NSString *)string
{
	[super setText:string];
	[self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)string
{
    if ( !placeholder )
    {
        [self addObserver];
    }
    
    placeholder = string;
	[self updatePlaceholder];
}


#pragma mark -
#pragma mark Default Value

- (UIColor*)placeholderColor
{
    if ( !placeholderColor )
    {
        // Match the color of UITextField. See the documentation of UITextField->placeholder
        placeholderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }
    return placeholderColor;
}




@end



