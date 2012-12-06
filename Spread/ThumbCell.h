//
//  ThumbCell.h
//  Spread
//
//  Created by Joseph Lin on 12/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"


@interface ThumbCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIButton *thumbButton;
@property (nonatomic, strong) Photo *photo;

@end
