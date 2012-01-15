//
//  EditViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/28/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"


typedef enum{
    EditModeCreate = 0,
    EditModeUpdate
}EditMode;


@interface EditViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *tagsView;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *tagsTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) NSDictionary* mediaInfo;
@property (strong, nonatomic) Photo *photo;
@property (nonatomic) EditMode editMode;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;

@end
