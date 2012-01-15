//
//  PlaceholderTextView.h
//  UI Element
//
//  Created by Joseph Lin on 10/24/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Intermediate object to intercept delegate calls, perform actions needed to emulate placeholder, and then pass calls to the real text view delegate.
 */
@interface PlaceholderTextViewDelegate : NSObject <UITextViewDelegate>
@end




@interface PlaceholderTextView : UITextView

@property (strong, nonatomic) UIColor *primaryTextColor;
@property (strong, nonatomic) UIColor *placeholderTextColor;
@property (copy, nonatomic) NSString *placeholderText;

@end


