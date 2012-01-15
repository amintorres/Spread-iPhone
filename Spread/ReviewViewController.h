//
//  ReviewViewController.h
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReviewViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSDictionary* mediaInfo;

- (IBAction)useButtonTapped:(id)sender;
- (IBAction)retakeButtonTapped:(id)sender;

@end
