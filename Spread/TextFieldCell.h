//
//  TextFieldCell.h
//  Spread
//
//  Created by Joseph Lin on 10/21/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RoundedType) {
    RoundedTypeNone = 0,
    RoundedTypeTop,
    RoundedTypeBottom,
};


@interface TextFieldCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic) RoundedType roundedType;
@end
