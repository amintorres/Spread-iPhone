//
//  UploadViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/9/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UploadViewControllerDelegate;


@interface UploadViewController : UIViewController

@property (nonatomic, weak) id <UploadViewControllerDelegate> delegate;

- (void)update;

@end


@protocol UploadViewControllerDelegate <NSObject>
- (void)shouldShowUploadViewController:(UploadViewController *)controller;
- (void)shouldHideUploadViewController:(UploadViewController *)controller;
@end