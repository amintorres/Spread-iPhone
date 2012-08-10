//
//  FourImagesCell.h
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FourImagesCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton* button0;
@property (nonatomic, strong) IBOutlet UIButton* button1;
@property (nonatomic, strong) IBOutlet UIButton* button2;
@property (nonatomic, strong) IBOutlet UIButton* button3;
@property (nonatomic, strong) NSArray* photos;

@end
