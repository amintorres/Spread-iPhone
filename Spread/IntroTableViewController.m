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

typedef enum{
    IntroViewStateIdle = 0,
    IntroViewStateLogin,
    IntroViewStateRegister,
} IntroViewState;



@interface IntroTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ButtonCell *facebookLoginCell;
@property (nonatomic, strong) ButtonCell *loginCell;
@property (nonatomic, strong) ButtonCell *registerCell;

@property (nonatomic, strong) TextFieldCell *firstNameCell;
@property (nonatomic, strong) TextFieldCell *lastNameCell;
@property (nonatomic, strong) TextFieldCell *nickNameCell;
@property (nonatomic, strong) TextFieldCell *emailCell;
@property (nonatomic, strong) TextFieldCell *passwordCell;
@property (nonatomic, strong) TextFieldCell *confirmPasswordCell;

@property (nonatomic) IntroViewState currentState;
@property (nonatomic) BOOL isAnimating;
@end



@implementation IntroTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    
    
    // Check for self.navigationController to make sure it's not a dummy instance.
    if ( [[ServiceManager sharedManager] isSessionValid] && self.navigationController )
    {
        [self performSegueWithIdentifier:@"MenuSegue" sender:self];
    }
    
    self.facebookLoginCell = [self blueButtonCellWithTitle:@"Login with Facebook" action:@selector(facebookLoginButtonTapped:)];
    self.loginCell = [self blueButtonCellWithTitle:@"Login with us" action:@selector(loginButtonTapped:)];
    self.registerCell = [self grayButtonCellWithTitle:@"Register" action:@selector(registerButtonTapped:)];

    self.firstNameCell = [self textFieldCellWithText:nil placeholder:@"First name"];
    self.lastNameCell = [self textFieldCellWithText:nil placeholder:@"Last name"];
    self.nickNameCell = [self textFieldCellWithText:nil placeholder:@"Nick name"];
    self.emailCell = [self textFieldCellWithText:nil placeholder:@"Email Address"];
    self.passwordCell = [self textFieldCellWithText:nil placeholder:@"Password"];
    self.confirmPasswordCell = [self textFieldCellWithText:nil placeholder:@"Confirm Passowrd"];
    
    
    self.dataSource = [@[
                       [@[self.facebookLoginCell, self.loginCell] mutableCopy],
                       ] mutableCopy ];
    
    self.currentState = IntroViewStateIdle;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.currentState = IntroViewStateIdle;
    [super viewDidDisappear:animated];
}

- (void)setCurrentState:(IntroViewState)state
{
    if (self.isAnimating)
        return;
    
    if (_currentState == IntroViewStateIdle && state == IntroViewStateLogin)
    {
        [self.dataSource[0] removeObject:self.facebookLoginCell];
        [self.dataSource[0] insertObject:self.emailCell atIndex:0];
        [self.dataSource[0] insertObject:self.passwordCell atIndex:1];
        
        [self.dataSource addObject:[@[self.registerCell] mutableCopy]];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];

        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if (_currentState == IntroViewStateLogin && state == IntroViewStateIdle)
    {
        [self.dataSource[0] removeObject:self.emailCell];
        [self.dataSource[0] removeObject:self.passwordCell];
        [self.dataSource[0] insertObject:self.facebookLoginCell atIndex:0];
        
        [self.dataSource removeObjectAtIndex:1];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    else if (_currentState == IntroViewStateLogin && state == IntroViewStateRegister)
    {
        [self.dataSource removeObjectAtIndex:0];
        [self.dataSource[0] insertObject:self.firstNameCell atIndex:0];
        [self.dataSource[0] insertObject:self.lastNameCell atIndex:1];
        [self.dataSource[0] insertObject:self.nickNameCell atIndex:2];
        [self.dataSource[0] insertObject:self.emailCell atIndex:3];
        [self.dataSource[0] insertObject:self.passwordCell atIndex:4];
        [self.dataSource[0] insertObject:self.confirmPasswordCell atIndex:5];
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:@[
         [NSIndexPath indexPathForRow:0 inSection:0],
         [NSIndexPath indexPathForRow:1 inSection:0],
         [NSIndexPath indexPathForRow:2 inSection:0],
         [NSIndexPath indexPathForRow:3 inSection:0],
         [NSIndexPath indexPathForRow:4 inSection:0],
         [NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    _currentState = state;
}

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

- (TextFieldCell *)textFieldCellWithText:(NSString *)text placeholder:(NSString *)placeholder
{
    TextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
    cell.textField.text = text;
    cell.textField.placeholder = placeholder;
    return cell;
}

#pragma mark - IBAction

- (IBAction)goBack:(id)sender
{
    if (self.currentState == IntroViewStateLogin)
    {
        [self.emailCell.textField resignFirstResponder];
        [self.passwordCell.textField resignFirstResponder];
        self.currentState = IntroViewStateIdle;
    }
    else if (self.currentState == IntroViewStateRegister)
    {
        [self.emailCell.textField resignFirstResponder];
        [self.passwordCell.textField resignFirstResponder];
        self.currentState = IntroViewStateLogin;
    }
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
        NSString* email = self.emailCell.textField.text;
        NSString* password = self.passwordCell.textField.text;
        [[ServiceManager sharedManager] loginWithEmail:email password:password completion:[self loginCompletionHandler]];
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
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"MenuSegue"] )
    {
    }
}


#pragma mark - Table view data source

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
    return self.dataSource[indexPath.section][indexPath.row];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
