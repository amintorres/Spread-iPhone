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
@property (assign, nonatomic) IBOutlet id <UITextViewDelegate> realDelegate;
@property (strong, nonatomic) PlaceholderTextViewDelegate *auxDelegate;
- (void)updateTextAndColor;
- (void)updateTextAndColorForEditing;
@end



@implementation PlaceholderTextView

@synthesize realDelegate;
@synthesize auxDelegate;
@synthesize primaryTextColor;
@synthesize placeholderTextColor;
@synthesize placeholderText;




#pragma mark -
#pragma mark Drawing Logic

- (void)updateTextAndColor
{
    if ( [[super text] length] == 0 )
    {
        [super setText:self.placeholderText];
        [super setTextColor:self.placeholderTextColor];
    }
    else
    {
        [super setTextColor:self.primaryTextColor];
    }
}

- (void)updateTextAndColorForEditing
{
    if ( [[super text] isEqualToString:self.placeholderText])
    {
        [super setText:@""];
        [super setTextColor:self.primaryTextColor];
    }
}


#pragma mark -
#pragma mark Setter/Accessor

- (UIColor*)textColor
{
    return self.primaryTextColor;
}

- (void)setTextColor:(UIColor *)color
{
    self.primaryTextColor = color;
    [self updateTextAndColor];
}

- (NSString *)text
{
    if ( [[super text] isEqualToString:self.placeholderText])
        return @"";
    else
        return [super text];
}

- (void)setText:(NSString *)string
{
    [super setText:string];
    [self updateTextAndColor];
}

- (void)setPlaceholderText:(NSString *)string
{
    placeholderText = string;
    
    [self updateTextAndColor];
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    self.realDelegate = delegate;
    [super setDelegate:self.auxDelegate];
}

- (id <UITextViewDelegate>)delegate
{
    return self.auxDelegate;
}

- (PlaceholderTextViewDelegate*)auxDelegate
{
    if ( !auxDelegate )
    {
        auxDelegate = [[PlaceholderTextViewDelegate alloc] init];
    }
    return auxDelegate;
}


#pragma mark -
#pragma mark Default Value

- (UIColor*)primaryTextColor
{
    if ( !primaryTextColor )
    {
        primaryTextColor = [UIColor darkGrayColor];
    }
    return primaryTextColor;
}

- (UIColor*)placeholderTextColor
{
    if ( !placeholderTextColor )
    {
        placeholderTextColor = [UIColor lightGrayColor];
    }
    return placeholderTextColor;
}


@end




@implementation PlaceholderTextViewDelegate


#pragma mark -
#pragma mark UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(PlaceholderTextView *)textView
{
    [textView updateTextAndColorForEditing];
    
    if ( [textView.realDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)] )
    {
        return [textView.realDelegate textViewShouldBeginEditing:textView];
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
        [textView resignFirstResponder];
        return NO;
    }
    else if ( [textView.realDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)] )
    {
        return [textView.realDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    else
    {
        return YES;
    }
}

- (void)textViewDidEndEditing:(PlaceholderTextView *)textView
{
    [textView updateTextAndColor];
    
    if ( [textView.realDelegate respondsToSelector:@selector(textViewDidEndEditing:)] )
    {
        [textView.realDelegate textViewDidEndEditing:textView];
    }
}



#pragma mark -
#pragma mark UITextView Delegate (Passthrough)

- (void)textViewDidBeginEditing:(PlaceholderTextView *)textView
{
    if ( [textView.realDelegate respondsToSelector:@selector(textViewDidBeginEditing:)] )
    {
        [textView.realDelegate textViewDidBeginEditing:textView];
    }
}

- (BOOL)textViewShouldEndEditing:(PlaceholderTextView *)textView
{
    if ( [textView.realDelegate respondsToSelector:@selector(textViewShouldEndEditing:)] )
    {
        return [textView.realDelegate textViewShouldEndEditing:textView];
    }
    else
    {
        return YES;
    }
}

- (void)textViewDidChange:(PlaceholderTextView *)textView
{    
    if ( [textView.realDelegate respondsToSelector:@selector(textViewDidChange:)] )
    {
        [textView.realDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(PlaceholderTextView *)textView
{
    if ( [textView.realDelegate respondsToSelector:@selector(textViewDidChangeSelection:)] )
    {
        [textView.realDelegate textViewDidChangeSelection:textView];
    }
}

@end


