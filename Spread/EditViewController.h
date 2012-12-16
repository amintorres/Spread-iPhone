//
//  EditViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/28/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo+Spread.h"

typedef NS_ENUM(NSUInteger, EditMode){
    EditModeCreate = 0,
    EditModeUpdate,
};


@interface EditViewController : UITableViewController

@property (strong, nonatomic) NSDictionary* mediaInfo;
@property (strong, nonatomic) Photo *photo;
@property (nonatomic) EditMode editMode;

@end
