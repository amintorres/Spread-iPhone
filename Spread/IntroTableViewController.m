//
//  IntroTableViewController.m
//  Spread
//
//  Created by Joseph Lin on 10/21/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "IntroTableViewController.h"
#import "ServiceManager.h"
#import "FacebookSDK.h"
#import "ButtonCell.h"
#import "TextFieldCell.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSUInteger, IntroViewState) {
    IntroViewStateIdle = 0,
    IntroViewStateLogin,
    IntroViewStateRegister,
};

typedef NS_ENUM(NSUInteger, KeyboardType) {
    KeyboardTypeText = 0,
    KeyboardTypeEmail,
    KeyboardTypePassword,
};


@interface IntroTableViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *facebookButtonSection;
@property (nonatomic, strong) NSArray *loginButtonSection;
@property (nonatomic, strong) NSArray *registerButtonSection;
@property (nonatomic, strong) NSArray *loginFormSecion;
@property (nonatomic, strong) NSArray *registerFormSecion;

@property (nonatomic, strong) NSIndexPath *activeIndexPath;

@property (nonatomic) IntroViewState currentState;
@property (nonatomic) BOOL isAnimating;
@end



@implementation IntroTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Check for self.navigationController to make sure it's not a dummy instance.
    if ( [[ServiceManager sharedManager] isSessionValid] && self.navigationController )
    {
        [self performSegueWithIdentifier:@"MenuSegue" sender:self];
    }
    
    self.dataSource = [@[
                       self.facebookButtonSection,
                       self.loginButtonSection
                       ] mutableCopy ];
    
    self.currentState = IntroViewStateIdle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.currentState = IntroViewStateIdle;
    
    [super viewDidDisappear:animated];
}


#pragma mark - View States

- (void)setCurrentState:(IntroViewState)state
{
    if (self.isAnimating)
        return;
    
    if (_currentState == IntroViewStateIdle && state == IntroViewStateLogin)
    {
        [self.dataSource removeObject:self.facebookButtonSection];
        [self.dataSource insertObject:self.loginFormSecion atIndex:0];
        [self.dataSource insertObject:self.registerButtonSection atIndex:2];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];

        [self scrollToBottom];
    }
    else if (_currentState == IntroViewStateLogin && state == IntroViewStateIdle)
    {
        [self.dataSource removeObject:self.loginFormSecion];
        [self.dataSource removeObject:self.registerButtonSection];
        [self.dataSource insertObject:self.facebookButtonSection atIndex:0];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [self scrollToBottom];
    }
    
    else if (_currentState == IntroViewStateLogin && state == IntroViewStateRegister)
    {
        [self.dataSource removeObject:self.loginFormSecion];
        [self.dataSource removeObject:self.loginButtonSection];
        [self.dataSource insertObject:self.registerFormSecion atIndex:0];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [self scrollToBottom];
    }
    
    else if (_currentState == IntroViewStateRegister && state == IntroViewStateLogin)
    {
        [self.dataSource removeObject:self.registerFormSecion];
        [self.dataSource insertObject:self.loginFormSecion atIndex:0];
        [self.dataSource insertObject:self.loginButtonSection atIndex:1];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [self scrollToBottom];
    }
    
    _currentState = state;
}

- (void)scrollToBottom
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self.dataSource lastObject] count] - 1 inSection:[self.dataSource count] - 1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)scrollCellBelowIndexPathToVisible:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource[indexPath.section] count]  - 1)
    {
        NSIndexPath *indexPathBelow = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [self.tableView scrollToRowAtIndexPath:indexPathBelow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - IBAction

- (IBAction)goBack:(id)sender
{
    if (self.currentState == IntroViewStateLogin)
    {
        self.currentState = IntroViewStateIdle;
    }
    else if (self.currentState == IntroViewStateRegister)
    {
        self.currentState = IntroViewStateLogin;
    }
}

- (ServiceManagerHandler)loginCompletionHandler
{
    return ^(id response, BOOL success, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];

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
        NSString* email    = ((TextFieldCell*)self.loginFormSecion[0]).textField.text;
        NSString* password = ((TextFieldCell*)self.loginFormSecion[1]).textField.text;
        
        if ([email length] && [password length])
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[ServiceManager sharedManager] loginWithEmail:email password:password completion:[self loginCompletionHandler]];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email/passowrd." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

- (IBAction)registerButtonTapped:(id)sender
{
    if ( self.currentState == IntroViewStateLogin )
    {
        self.currentState = IntroViewStateRegister;
    }
    else
    {
        NSString* firsName        = ((TextFieldCell*)self.registerFormSecion[0]).textField.text;
        NSString* lastName        = ((TextFieldCell*)self.registerFormSecion[1]).textField.text;
        NSString* nickname        = ((TextFieldCell*)self.registerFormSecion[2]).textField.text;
        NSString* email           = ((TextFieldCell*)self.registerFormSecion[3]).textField.text;
        NSString* password        = ((TextFieldCell*)self.registerFormSecion[4]).textField.text;
        NSString* confirmPassword = ((TextFieldCell*)self.registerFormSecion[5]).textField.text;
        
        if ([firsName length] && [lastName length] && [nickname length] && [email length] && [password length] && [confirmPassword length])
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Registeration not avaliable yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"All fields are required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"MenuSegue"] )
    {
    }
}


#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.dataSource[indexPath.section][indexPath.row];
    if ([cell isKindOfClass:[TextFieldCell class]])
        return 50;
    else
        return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.dataSource[indexPath.section][indexPath.row];
    
    if ([cell isKindOfClass:[TextFieldCell class]])
    {
        if (indexPath.row == 0)
            ((TextFieldCell*)cell).roundedType = RoundedTypeTop;
        else if (indexPath.row == [self.dataSource[indexPath.section] count] - 1)
            ((TextFieldCell*)cell).roundedType = RoundedTypeBottom;
        else
            ((TextFieldCell*)cell).roundedType = RoundedTypeNone;
    }
    
    return cell;
}


#pragma mark - Data Source

- (NSArray *)facebookButtonSection
{
    if (!_facebookButtonSection)
    {
        _facebookButtonSection = @[
        [self blueButtonCellWithTitle:@"Login with Facebook" action:@selector(facebookLoginButtonTapped:)],
        ];
    }
    return _facebookButtonSection;
}

- (NSArray *)loginButtonSection
{
    if (!_loginButtonSection)
    {
        _loginButtonSection = @[
        [self blueButtonCellWithTitle:@"Login with us" action:@selector(loginButtonTapped:)],
        ];
    }
    return _loginButtonSection;
}

- (NSArray *)registerButtonSection
{
    if (!_registerButtonSection)
    {
        _registerButtonSection = @[
        [self grayButtonCellWithTitle:@"Register" action:@selector(registerButtonTapped:)],
        ];
    }
    return _registerButtonSection;
}

- (NSArray *)loginFormSecion
{
    if (!_loginFormSecion)
    {
        _loginFormSecion = @[
        [self textFieldCellWithText:nil placeholder:@"Email Address" keyboard:KeyboardTypeEmail],
        [self textFieldCellWithText:nil placeholder:@"Password" keyboard:KeyboardTypePassword],
        ];
    }
    return _loginFormSecion;
}

- (NSArray *)registerFormSecion
{
    if (!_registerFormSecion)
    {
        _registerFormSecion = @[
        [self textFieldCellWithText:nil placeholder:@"First name" keyboard:KeyboardTypeText],
        [self textFieldCellWithText:nil placeholder:@"Last name" keyboard:KeyboardTypeText],
        [self textFieldCellWithText:nil placeholder:@"Nick name" keyboard:KeyboardTypeText],
        [self textFieldCellWithText:nil placeholder:@"Email Address" keyboard:KeyboardTypeEmail],
        [self textFieldCellWithText:nil placeholder:@"Password" keyboard:KeyboardTypePassword],
        [self textFieldCellWithText:nil placeholder:@"Confirm Password" keyboard:KeyboardTypePassword],
        ];
    }
    return _registerFormSecion;
}


#pragma mark - Cell Shortcuts

- (ButtonCell *)blueButtonCellWithTitle:(NSString *)title action:(SEL)action
{
    ButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BlueButtonCell"];
    [cell.button setTitle:title forState:UIControlStateNormal];
    [cell.button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (ButtonCell *)grayButtonCellWithTitle:(NSString *)title action:(SEL)action
{
    ButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GrayButtonCell"];
    [cell.button setTitle:title forState:UIControlStateNormal];
    [cell.button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (TextFieldCell *)textFieldCellWithText:(NSString *)text placeholder:(NSString *)placeholder keyboard:(KeyboardType)keyboard
{
    TextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
    cell.textField.text = text;
    cell.textField.placeholder = placeholder;
    cell.textField.delegate = self;
    
    switch (keyboard) {
        case KeyboardTypeEmail:
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.textField.autocorrectionType = NO;
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textField.secureTextEntry = NO;
            break;
            
        case KeyboardTypePassword:
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.textField.autocorrectionType = NO;
            cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
            cell.textField.secureTextEntry = YES;
            break;
            
        case KeyboardTypeText:
        default:
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.textField.autocorrectionType = YES;
            cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
            cell.textField.secureTextEntry = NO;
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
    
    if ([cell isKindOfClass:[UITableViewCell class]])
    {
        // If keyboard is not shown, do the scrolling in [keyboardWillShow:]; othwise, scroll here.
        BOOL shouldScroll = (!self.activeIndexPath);
        
        self.activeIndexPath = [self.tableView indexPathForCell:cell];

        // Scroll a row below to visible, so the user can continue to input.
        if (shouldScroll)
        {
            [self scrollCellBelowIndexPathToVisible:self.activeIndexPath];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.swipeGestureRecognizer.enabled = NO;
    [self scrollCellBelowIndexPathToVisible:self.activeIndexPath];
}

- (void)keyboardDidHide:(NSNotification *)notification
{    
    self.swipeGestureRecognizer.enabled = YES;
    [self scrollToBottom];
}


@end
