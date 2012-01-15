//
//  IntroViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "IntroViewController.h"
#import "MasterViewController.h"
#import "UILabel+Crossfade.h"
#import "UITextField+Crossfade.h"
#import "UIView+Shortcut.h"
#import "ServiceManager.h"


typedef enum{
    IntroViewStateIdle = 0,   
    IntroViewStateLogin,   
    IntroViewStateInvite,   
} IntroViewState;

typedef enum{
    AnimateDirectionUp = -1,
    AnimateDirectionDown = 1,   
} AnimateDirection;

static const CGFloat kHeaderImageViewY          = 0;
static const CGFloat kLogoButtonY               = 290;
static const CGFloat kCaptionLabelY             = 320;
static const CGFloat kStartButtonY              = 400;
static const CGFloat kTextFieldContainerViewY   = 510;
static const CGFloat kLoginButtonY              = 610;
static const CGFloat kInviteCaptionLabelY       = 730;
static const CGFloat kInviteButtonY             = 760;

static const CGFloat kGroup0LoginOffset         = 300;
static const CGFloat kGroup1LoginOffset         = 260;
static const CGFloat kGroup2LoginOffset         = 370;
static const CGFloat kGroup2InviteOffset        = 150;




@interface IntroViewController ()
@property (nonatomic) IntroViewState currentState;
@property (nonatomic) BOOL isAnimating;
- (void)setIdleState;
@end


@implementation IntroViewController

@synthesize headerImageView;
@synthesize logoButton;
@synthesize captionLabel;
@synthesize startButton;
@synthesize textFieldContainerView;
@synthesize textField0;
@synthesize textField1;
@synthesize loginButton;
@synthesize inviteCaptionLabel;
@synthesize inviteButton;
@synthesize currentState;
@synthesize isAnimating;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self setIdleState];
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    self.headerImageView = nil;
    self.logoButton = nil;
    self.captionLabel = nil;
    self.startButton = nil;
    self.textFieldContainerView = nil;
    self.textField0 = nil;
    self.textField1 = nil;
    self.loginButton = nil;
    self.inviteCaptionLabel = nil;
    self.inviteButton = nil;
    [super viewDidUnload];
}


- (void)setIdleState
{
    [headerImageView setY:kHeaderImageViewY];
    [logoButton setY:kLogoButtonY];
    [captionLabel setY:kCaptionLabelY];
    [startButton setY:kStartButtonY];
    [textFieldContainerView setY:kTextFieldContainerViewY];
    [loginButton setY:kLoginButtonY];
    [inviteCaptionLabel setY:kInviteCaptionLabelY];
    [inviteButton setY:kInviteButtonY];
    
    startButton.alpha = 1.0;
    loginButton.alpha = 1.0;
    inviteCaptionLabel.alpha = 1.0;
    
    textField0.text = nil;
    textField1.text = nil;
}

- (void)setLoginState
{
    [headerImageView setY:kHeaderImageViewY - kGroup0LoginOffset];

    [logoButton setY:kLogoButtonY - kGroup1LoginOffset];
    [captionLabel setY:kCaptionLabelY - kGroup1LoginOffset];
    [startButton setY:kStartButtonY - kGroup1LoginOffset];
    
    [textFieldContainerView setY:kTextFieldContainerViewY - kGroup2LoginOffset];
    [loginButton setY:kLoginButtonY - kGroup2LoginOffset];
    [inviteCaptionLabel setY:kInviteCaptionLabelY - kGroup2LoginOffset];
    [inviteButton setY:kInviteButtonY - kGroup2LoginOffset];
    
    startButton.alpha = 0.0;
    loginButton.alpha = 1.0;
    inviteCaptionLabel.alpha = 1.0;
    
    //// TextField 1 is password ////
    textField1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField1.autocorrectionType = UITextAutocorrectionTypeNo;
    textField1.secureTextEntry = YES;
}

- (void)setLoginStateKeyboardOpen
{
    CGFloat keyboardOffset = 70.0;
    
    [logoButton setY:kLogoButtonY - kGroup1LoginOffset - keyboardOffset];
    [captionLabel setY:kCaptionLabelY - kGroup1LoginOffset - keyboardOffset];
    
    [textFieldContainerView setY:kTextFieldContainerViewY - kGroup2LoginOffset - keyboardOffset];
    [loginButton setY:kLoginButtonY - kGroup2LoginOffset - keyboardOffset];
    [inviteCaptionLabel setY:kInviteCaptionLabelY - kGroup2LoginOffset - keyboardOffset];
    [inviteButton setY:kInviteButtonY - kGroup2LoginOffset - keyboardOffset];
}

- (void)setInviteState
{
    [headerImageView setY:kHeaderImageViewY - kGroup0LoginOffset];
    
    [logoButton setY:kLogoButtonY - kGroup1LoginOffset];
    [captionLabel setY:kCaptionLabelY - kGroup1LoginOffset];
    [startButton setY:kStartButtonY - kGroup1LoginOffset];
    
    [textFieldContainerView setY:kTextFieldContainerViewY - kGroup2LoginOffset];
    [loginButton setY:kLoginButtonY - kGroup2LoginOffset];
    
    [inviteCaptionLabel setY:kInviteCaptionLabelY - kGroup2LoginOffset - kGroup2InviteOffset];
    [inviteButton setY:kInviteButtonY - kGroup2LoginOffset - kGroup2InviteOffset];
    
    startButton.alpha = 0.0;
    loginButton.alpha = 0.0;
    inviteCaptionLabel.alpha = 0.0;

    //// TextField 1 is full name ////
    textField1.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField1.autocorrectionType = UITextAutocorrectionTypeYes;
    textField1.secureTextEntry = NO;  
}

- (void)setInviteStateKeyboardOpen
{
    CGFloat keyboardOffset = 70.0;

    [logoButton setY:kLogoButtonY - kGroup1LoginOffset - keyboardOffset];
    [captionLabel setY:kCaptionLabelY - kGroup1LoginOffset - keyboardOffset];
    
    [textFieldContainerView setY:kTextFieldContainerViewY - kGroup2LoginOffset - keyboardOffset];

    [inviteCaptionLabel setY:kInviteCaptionLabelY - kGroup2LoginOffset - kGroup2InviteOffset - keyboardOffset];
    [inviteButton setY:kInviteButtonY - kGroup2LoginOffset - kGroup2InviteOffset - keyboardOffset];
}

- (void)animateToState:(IntroViewState)state
{
    if ( isAnimating )
        return;
    

    currentState = state;
    
    NSString* caption = nil;
    NSString* textField1PlaceHolder = nil;
    
    switch (currentState)
    {
        case IntroViewStateIdle:
            caption = @"Spread is platform that allows citizens to capture news worthy photographs and make themavailable to blogs and news organizations for purchase.";
            break;
            
        case IntroViewStateLogin:
            caption = @"Spread is invite only for now.\nUse your email and and\npassword bellow to log in.";
            textField1PlaceHolder = @"Password";
            break;
            
        case IntroViewStateInvite:
        default:
            caption = @"Requesting an invite.\nFill the short form bellow and we will\nsend you an invitation code.";
            textField1PlaceHolder = @"Full name";
            break;
    }
    
    [captionLabel crossFadeToText:caption duration:0.7];
    [textField1 crossFadeToPlaceHolder:textField1PlaceHolder duration:0.7];
    
    isAnimating = YES;
    
    [UIView animateWithDuration:0.7 animations:^(void){
        
        switch (currentState)
        {
            case IntroViewStateIdle:
                [self setIdleState];
                break;
                
            case IntroViewStateLogin:
                [self setLoginState];
                break;
                
            case IntroViewStateInvite:
            default:
                [self setInviteState];
                break;
        }

        
    } completion:^(BOOL finished){
        isAnimating = NO;
    }];
}


- (IBAction)logoButtonTapped:(id)sender
{
    [self animateToState:IntroViewStateIdle];
}

- (IBAction)startButtonTapped:(id)sender
{
    [self animateToState:IntroViewStateLogin];
}

- (IBAction)loginButtonTapped:(id)sender
{
    NSString* username = textField0.text;
    NSString* password = textField1.text;
    [ServiceManager loginWithUsername:username password:password];
}

- (IBAction)inviteButtonTapped:(id)sender
{
    if ( currentState == IntroViewStateInvite )
    {
        NSString* email = textField0.text;
        NSString* name = textField1.text;
        // TODO: Invite API
        [ServiceManager requestInviteWithEmail:email name:name];
    }
    else
    {
        textField1.text = nil;
        [self animateToState:IntroViewStateInvite];
    }
}


#pragma mark -
#pragma mark TextField Delegate

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^(void){
        
        switch (currentState)
        {
            case IntroViewStateIdle:
                break;
                
            case IntroViewStateLogin:
                [self setLoginStateKeyboardOpen];
                break;
                
            case IntroViewStateInvite:
            default:
                [self setInviteStateKeyboardOpen];
                break;
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^(void){
        
        switch (currentState)
        {
            case IntroViewStateIdle:
                break;
                
            case IntroViewStateLogin:
                [self setLoginState];
                break;
                
            case IntroViewStateInvite:
            default:
                [self setInviteState];
                break;
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
