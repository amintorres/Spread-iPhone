//
//  RequestEditViewController.h
//  Spread
//
//  Created by Joseph Lin on 3/16/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo+Spread.h"


@interface RequestEditViewController : UIViewController

@property (strong, nonatomic) NSDictionary* mediaInfo;
@property (strong, nonatomic) Photo *photo;

@end
