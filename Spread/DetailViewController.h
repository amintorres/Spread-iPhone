//
//  DetailViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
