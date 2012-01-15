//
//  PlaceholderTextView.m
//  PhotoMob
//
//  Created by Joseph Lin on 10/24/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "PlaceholderTextView.h"
#import <QuartzCore/QuartzCore.h>



@implementation PlaceholderTextView

@synthesize delegate;
@synthesize textView;
@synthesize textColor;
@synthesize placeholderTextColor;
@synthesize placeholderText;


- (void)initialize
{
    self.textColor = [UIColor darkGrayColor];
    self.placeholderTextColor = [UIColor lightGrayColor];
    
    self.textView = [[UITextView alloc] initWithFrame:self.bounds];
    textView.delegate = self;
    [self addSubview:textView];
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if(self)
    {
        [self initialize];
    }
    return self;
}
               
- (id) initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    textView.frame = self.bounds;
}

- (void)updateView
{
    if ( [textView.text length] == 0 )
    {
        textView.text = placeholderText;
        textView.textColor = placeholderTextColor;
    }
    else
    {
        textView.textColor = textColor;        
    }
}


- (UIColor*)textColor
{
    return textView.textColor;
}

- (void)setTextColor:(UIColor *)color
{
    textColor = color;

    [self updateView];
}

- (NSString *)text
{
    if ( [textView.text isEqualToString:placeholderText])
        return nil;
    else
        return textView.text;
}

- (void)setText:(NSString *)string
{
    textView.text = string;
    [self updateView];
}

- (void)setPlaceholderText:(NSString *)string
{
    placeholderText = string;
    
    [self updateView];
}

- (UIReturnKeyType)returnKeyType
{
    return textView.returnKeyType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    textView.returnKeyType = returnKeyType;
}

- (BOOL)scrollEnabled
{
    return textView.scrollEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    textView.scrollEnabled = scrollEnabled;
}

- (BOOL)resignFirstResponder
{
    [textView resignFirstResponder];
    return [super resignFirstResponder];
}


#pragma mark -
#pragma mark UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(PlaceholderTextView *)textView
{
    if ( [self.textView.text isEqualToString:placeholderText])
    {
        self.textView.text = @"";
        self.textView.textColor = textColor;
    }
    
    if ( [delegate respondsToSelector:@selector(textViewShouldBeginEditing:)] )
    {
        return [delegate textViewShouldBeginEditing:self.textView];
    }
    else
    {
        return YES;
    }
}

- (BOOL)textView:(PlaceholderTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] )
    {
        [self.textView resignFirstResponder];
        return NO;
    }
    else if ( [delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)] )
    {
        return [delegate textView:self.textView shouldChangeTextInRange:range replacementText:text];
    }
    else
    {
        return YES;
    }
}

- (void)textViewDidEndEditing:(PlaceholderTextView *)textView
{
    [self updateView];

    if ( [delegate respondsToSelector:@selector(textViewDidEndEditing:)] )
    {
        [delegate textViewDidEndEditing:self.textView];
    }
}



#pragma mark -
#pragma mark UITextView Delegate (Passthrough)

- (void)textViewDidBeginEditing:(PlaceholderTextView *)textView
{
    if ( [delegate respondsToSelector:@selector(textViewDidBeginEditing:)] )
    {
        [delegate textViewDidBeginEditing:self.textView];
    }
}

- (BOOL)textViewShouldEndEditing:(PlaceholderTextView *)textView
{
    if ( [delegate respondsToSelector:@selector(textViewShouldEndEditing:)] )
    {
        return [delegate textViewShouldEndEditing:self.textView];
    }
    else
    {
        return YES;
    }
}

- (void)textViewDidChange:(PlaceholderTextView *)textView
{    
    if ( [delegate respondsToSelector:@selector(textViewDidChange:)] )
    {
        [delegate textViewDidChange:self.textView];
    }
}

- (void)textViewDidChangeSelection:(PlaceholderTextView *)textView
{
    if ( [delegate respondsToSelector:@selector(textViewDidChangeSelection:)] )
    {
        [delegate textViewDidChangeSelection:self.textView];
    }
}





@end
