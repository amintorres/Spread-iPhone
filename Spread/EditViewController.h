//
//  EditViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/28/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo+Spread.h"
#import "PlaceholderTextView.h"


typedef enum{
    EditModeCreate = 0,
    EditModeUpdate
}EditMode;


@interface EditViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *tagsTextField;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UISwitch *rememberDetailSwitch;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) NSDictionary* mediaInfo;
@property (strong, nonatomic) Photo *photo;
@property (nonatomic) EditMode editMode;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;
- (IBAction)rememberDetailsSwitchValueChanged:(UISwitch*)sender;

@end
