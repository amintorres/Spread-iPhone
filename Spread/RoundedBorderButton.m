//
//  RoundedBorderButton.m
//  Spread
//
//  Created by Joseph Lin on 1/28/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "RoundedBorderButton.h"


@implementation RoundedBorderButton

@synthesize cornerRadius, borderWidth, borderColor, borderHighlightedColor;


- (void)initialize
{
    self.borderColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    self.borderHighlightedColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    self.cornerRadius = 5.0;
    self.borderWidth = 3.0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initialize];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self initialize];
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( self.isHighlighted )
    {
        [borderHighlightedColor setStroke];        
    }
    else
    {
        [borderColor setStroke];
    }
    CGContextSetLineWidth(context, borderWidth);
    
    CGRect insetRect = CGRectInset(rect, borderWidth, borderWidth);
    
    CGContextMoveToPoint(context, insetRect.origin.x, insetRect.origin.y + cornerRadius);
    CGContextAddLineToPoint(context, insetRect.origin.x, insetRect.origin.y + insetRect.size.height - cornerRadius);
    CGContextAddArc(context, insetRect.origin.x + cornerRadius, insetRect.origin.y + insetRect.size.height - cornerRadius, cornerRadius, M_PI, M_PI / 2, 1);
    CGContextAddLineToPoint(context, insetRect.origin.x + insetRect.size.width - cornerRadius, insetRect.origin.y + insetRect.size.height);
    CGContextAddArc(context, insetRect.origin.x + insetRect.size.width - cornerRadius, insetRect.origin.y + insetRect.size.height - cornerRadius, cornerRadius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, insetRect.origin.x + insetRect.size.width, insetRect.origin.y + cornerRadius);
    CGContextAddArc(context, insetRect.origin.x + insetRect.size.width - cornerRadius, insetRect.origin.y + cornerRadius, cornerRadius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, insetRect.origin.x + cornerRadius, insetRect.origin.y);
    CGContextAddArc(context, insetRect.origin.x + cornerRadius, insetRect.origin.y + cornerRadius, cornerRadius, -M_PI / 2, M_PI, 1);
    
    CGContextStrokePath(context);
}

@end
