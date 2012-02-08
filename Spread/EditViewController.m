//
//  EditViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/28/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "EditViewController.h"
#import "ServiceManager.h"
#import "UINavigationBar+Customize.h"
#import "UserDefaultHelper.h"


typedef enum{
    EditTableViewRowTitle = 0,
    EditTableViewRowTags,
    EditTableViewRowDescription,
    EditTableViewRowCount
} EditTableViewRow;



@interface EditViewController ()
@property (strong, nonatomic) UIView *activeResponder;
- (void)registerForKeyboardNotifications;
@end



@implementation EditViewController

@synthesize tableView, titleView, tagsView, descriptionView, titleTextField, tagsTextField, descriptionTextView, sectionFooterView, rememberDetailSwitch;
@synthesize navigationBar, saveButton, deleteButton;
@synthesize mediaInfo;
@synthesize photo;
@synthesize editMode;
@synthesize activeResponder;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationBar customizeBackground];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    
    descriptionTextView.placeholder = @"Add as much detail as possible";
    
    if ( editMode == EditModeCreate )
    {
        saveButton.title = @"Save";
        tableView.tableFooterView = nil;
        
        self.photo = [Photo object];
        
        if ( [UserDefaultHelper shouldStoreDetails] )
        {
            [photo loadDetailsFromUserDefault];
            rememberDetailSwitch.on = YES;
        }
    }
    else
    {
        saveButton.title = @"Update";
        deleteButton.layer.masksToBounds = YES;
        deleteButton.layer.cornerRadius = 5.0;
        deleteButton.layer.borderWidth = 2.0;
        deleteButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    }
    
    titleTextField.text = photo.title;
    tagsTextField.text = photo.csvTags;
    descriptionTextView.text = photo.photoDescription;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ( [UserDefaultHelper shouldStoreDetails] )
    {
        [photo storeDetailsToUserDefault];
    }

    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    self.tableView = nil;
    self.titleView = nil;
    self.tagsView = nil;
    self.descriptionView = nil;
    self.titleTextField = nil;
    self.tagsTextField = nil;
    self.descriptionTextView = nil;
    self.sectionFooterView = nil;
    self.rememberDetailSwitch = nil;
    self.navigationBar = nil;
    self.saveButton = nil;
    self.deleteButton = nil;
    [super viewDidUnload];
}

- (void)postPhotoAtURL:(NSURL*)assetURL
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];

    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *imageRepresentation = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(imageRepresentation.size);
        NSUInteger buffered = [imageRepresentation getBytes:buffer fromOffset:0.0 length:imageRepresentation.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        [ServiceManager postPhoto:photo imageData:data];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"Error loading image: %@", error);
    }]; 
}


#pragma mark -
#pragma mark IBAction

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonTapped:(id)sender
{
    photo.capturedDate = [NSDate date];
    photo.title = titleTextField.text;
    photo.csvTags = tagsTextField.text;
    photo.photoDescription = descriptionTextView.text;
    
    NSError* error = nil;
    if ( ![photo validate:&error] )
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if ( editMode == EditModeCreate )
    {
        UIImage* image = [mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary* metaData = [mediaInfo objectForKey:UIImagePickerControllerMediaMetadata];
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        UIImagePickerController* picker = (UIImagePickerController*)self.navigationController;
        
        if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
        {
            [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:metaData completionBlock:^(NSURL* assetURL, NSError* error){
                
                [self postPhotoAtURL:assetURL];    
            }];
        }
        else
        {
            NSURL* assetURL = [mediaInfo objectForKey:UIImagePickerControllerReferenceURL];
            [self postPhotoAtURL:assetURL];
        }
    }
    else
    {
        [ServiceManager updatePhoto:photo];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)deleteButtonTapped:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Deleting this photo" message:@"Are you sure you want to delete this photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, Delete", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex != alertView.cancelButtonIndex )
    {
        [ServiceManager deletePhoto:photo];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)rememberDetailsSwitchValueChanged:(UISwitch*)sender
{
    [UserDefaultHelper setShouldStoreDetails:sender.isOn];
}


#pragma mark -
#pragma mark TableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Details";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( editMode == EditModeCreate )
    {
        return sectionFooterView.bounds.size.height;    
    }
    else
    {
        return 5.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( editMode == EditModeCreate )
    {
        return sectionFooterView;       
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return EditTableViewRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case EditTableViewRowTitle:
        case EditTableViewRowTags:
            return 44;
            
        case EditTableViewRowDescription:
        default:
            return descriptionTextView.contentSize.height + 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* reuseIdentifier = @"EditTableViewCell";
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
	}
    

    CGRect rect = CGRectInset(cell.contentView.bounds, 10, 5);

    switch (indexPath.row)
    {
        case EditTableViewRowTitle:
            titleView.frame = rect;
            [cell.contentView addSubview:titleView];
            break;
            
        case EditTableViewRowTags:
            tagsView.frame = rect;
            [cell.contentView addSubview:tagsView];
            break;
            
        case EditTableViewRowDescription:
        default:
            descriptionView.frame = rect;
            [cell.contentView addSubview:descriptionView];
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



