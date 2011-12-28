//
//  EditViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/28/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "EditViewController.h"

typedef enum{
    EditTableViewSectionTitle = 0,
    EditTableViewSectionTags,
    EditTableViewSectionDescription,
    EditTableViewSectionCount
} EditTableViewSection;



@interface EditViewController ()

@property (strong, nonatomic) UIView *activeResponder;

- (void)registerForKeyboardNotifications;

@end



@implementation EditViewController

@synthesize tableView;
@synthesize titleTextField;
@synthesize tagsTextField;
@synthesize descriptionTextView;
@synthesize activeResponder;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
}

- (void)viewDidUnload
{
    self.tableView = nil;
    self.titleTextField = nil;
    self.tagsTextField = nil;
    self.descriptionTextView = nil;
    [super viewDidUnload];
}


#pragma mark -
#pragma mark IBAction

- (IBAction)cancelButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EditTableViewSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case EditTableViewSectionTitle:
            return @"Title";
            
        case EditTableViewSectionTags:
            return @"Tags";
            
        case EditTableViewSectionDescription:
        default:
            return @"Description";
    }
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case EditTableViewSectionTitle:
        case EditTableViewSectionTags:
            return 44;
            
        case EditTableViewSectionDescription:
        default:
            return descriptionTextView.contentSize.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* reuseIdentifier = @"EditTableViewCell";
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	}
    

    CGRect rect = CGRectInset(cell.contentView.bounds, 10, 5);

    switch (indexPath.section)
    {
        case EditTableViewSectionTitle:
            titleTextField.frame = rect;
            [cell.contentView addSubview:titleTextField];
            break;
            
        case EditTableViewSectionTags:
            tagsTextField.frame = rect;
            [cell.contentView addSubview:tagsTextField];
            break;
            
        case EditTableViewSectionDescription:
        default:
            descriptionTextView.frame = rect;
            [cell.contentView addSubview:descriptionTextView];
            break;
    }

	return cell;
}



#pragma mark -
#pragma mark Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
        tableView.contentInset = contentInsets;
        tableView.scrollIndicatorInsets = contentInsets;        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        tableView.contentInset = contentInsets;
        tableView.scrollIndicatorInsets = contentInsets;
    }];
}


#pragma mark -
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeResponder = textField;
    
    NSIndexPath* indexPath = [tableView indexPathForCell:(UITableViewCell*)textField.superview.superview];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeResponder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.activeResponder = textView;
    
    NSIndexPath* indexPath = [tableView indexPathForCell:(UITableViewCell*)textView.superview.superview];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.activeResponder = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] )
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //// These will trigger tableview's resize animation. ////
    [tableView beginUpdates];
    [tableView endUpdates];
}


@end



