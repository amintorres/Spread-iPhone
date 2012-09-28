//
//  IntroViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "IntroViewController.h"
#import "ServiceManager.h"
#import "FacebookSDK.h"

typedef enum{
    IntroViewStateIdle = 0,   
    IntroViewStateLogin,   
    IntroViewStateLoginWithKeyboard,
} IntroViewState;



@interface IntroViewController ()
@property (nonatomic) IntroViewState currentState;
@property (nonatomic) BOOL isAnimating;
@end



@implementation IntroViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    // Check for self.navigationController to make sure it's not a dummy instance.
    if ( [[ServiceManager sharedManager] isSessionValid] && self.navigationController )
    {
        [self performSegueWithIdentifier:@"MenuSegue" sender:self];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.currentState = IntroViewStateIdle;
    [super viewDidDisappear:animated];
}


#pragma mark - View States Management

- (void)setCurrentState:(IntroViewState)theState
{
    if (self.isAnimating)
        return;
    
    _currentState = theState;
    
    switch (_currentState)
    {
        case IntroViewStateLogin:
            [self showStateWithReference:[IntroViewController loginState]];
            break;
            
        case IntroViewStateLoginWithKeyboard:
            [self showStateWithReference:[IntroViewController loginWithKeyboardState]];
            break;
            
        default:
            [self showStateWithReference:[IntroViewController idleState]];
            self.emailTextField.text = nil;
            self.passwordTextField.text = nil;
            break;
    }
}

- (void)showStateWithReference:(IntroViewController*)reference
{
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self configUIElement:self.headerImageView withReferenceElement:reference.headerImageView];
        [self configUIElement:self.logoButton withReferenceElement:reference.logoButton];
        [self configUIElement:self.captionLabel withReferenceElement:reference.captionLabel];
        [self configUIElement:self.facebookLoginButton withReferenceElement:reference.facebookLoginButton];
        [self configUIElement:self.loginButton withReferenceElement:reference.loginButton];
        [self configUIElement:self.textFieldContainerView withReferenceElement:reference.textFieldContainerView];
        [self configUIElement:self.registerLabel withReferenceElement:reference.registerLabel];
        [self configUIElement:self.registerButton withReferenceElement:reference.registerButton];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

- (void)configUIElement:(UIView*)element withReferenceElement:(UIView*)referenceElement
{
    element.frame = referenceElement.frame;
    element.alpha = referenceElement.alpha;
    if ([element.subviews count])
    {
        for ( UIView* subview in element.subviews )
        {
            subview.alpha = referenceElement.alpha;
        }
    }
}


#pragma mark - IBAction

- (IBAction)logoButtonTapped:(id)sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

    self.currentState = IntroViewStateIdle;
}

- (ServiceManagerHandler)loginCompletionHandler
{
    return ^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            [self performSegueWithIdentifier:@"MenuSegue" sender:self];
        }
        else
        {
            NSString* message = nil;
            
            if ([response isKindOfClass:[NSDictionary class]])
            {
                message = response[@"message"];
            }
            
            if (!message)
            {
                message = error.localizedDescription;
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    };
}

- (IBAction)facebookLoginButtonTapped:(id)sender
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      
                                      if ( session.isOpen )
                                      {
                                          NSLog(@"Facebook login successed!");
                                          [[ServiceManager sharedManager] loginWithFacebookToken:session.accessToken completion:[self loginCompletionHandler]];
                                      }
                                      
                                      if (error)
                                      {
                                          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                          [alertView show];
                                      }
                                  }];
}

- (IBAction)loginButtonTapped:(id)sender
{
    if ( self.currentState == IntroViewStateIdle )
    {
        self.currentState = IntroViewStateLogin;
    }
    else
    {
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        NSString* email = self.emailTextField.text;
        NSString* password = self.passwordTextField.text;
        [[ServiceManager sharedManager] loginWithEmail:email password:password completion:[self loginCompletionHandler]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"MenuSegue"] )
    {
    }
}


#pragma mark - TextField Delegate

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.currentState == IntroViewStateLogin)
    {
        self.currentState = IntroViewStateLoginWithKeyboard;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.currentState == IntroViewStateLoginWithKeyboard)
    {
        self.currentState = IntroViewStateLogin;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Singletons for layout reference

+ (IntroViewController*)idleState
{
    static IntroViewController *_idleState = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _idleState = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
        [_idleState view];
    });
    
    return _idleState;
}

+ (IntroViewController*)loginState
{
    static IntroViewController *_loginState = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _loginState = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewControllerLogin"];
        [_loginState view];
    });
    
    return _loginState;
}

+ (IntroViewController*)loginWithKeyboardState
{
    static IntroViewController *_loginWithKeyboardState = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _loginWithKeyboardState = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewControllerLoginWithKeyboard"];
        [_loginWithKeyboardState view];
    });
    
    return _loginWithKeyboardState;
}

@end
