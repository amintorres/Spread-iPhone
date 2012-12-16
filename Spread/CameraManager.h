//
//  CameraManager.h
//  Spread
//
//  Created by Joseph Lin on 12/16/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CameraManager : NSObject

@property (nonatomic, strong) UIViewController *presentingViewController;

- (void)launchImagePickerInView:(UIViewController *)controller;
+ (CameraManager *)sharedManager;

@end
