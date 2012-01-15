//
//  PlaceholderTextView.h
//  PhotoMob
//
//  Created by Joseph Lin on 10/24/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PlaceholderTextViewDelegate;

@interface PlaceholderTextView : UIView <UITextViewDelegate>

@property (assign, nonatomic) IBOutlet id <PlaceholderTextViewDelegate> delegate;
@property (strong, nonatomic) UITextView* textView;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *placeholderTextColor;
@property (copy, nonatomic) NSString *placeholderText;

@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) UIReturnKeyType returnKeyType;
@property (assign, nonatomic) BOOL scrollEnabled;

- (void)updateView;

@end


@protocol PlaceholderTextViewDelegate <NSObject, UITextViewDelegate>
@end
