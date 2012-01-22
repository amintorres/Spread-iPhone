//
//  GridTableViewCell.h
//  Spread
//
//  Created by Joseph Lin on 1/17/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"


@interface GridTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UIImageView *middleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;
@property (strong, nonatomic) NSArray* photos;

- (IBAction)leftButtonTapped:(id)sender;
- (IBAction)middleButtonTapped:(id)sender;
- (IBAction)rightButtonTapped:(id)sender;

@end
