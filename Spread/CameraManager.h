//
//  CameraManager.h
//  Spread
//
//  Created by Joseph Lin on 12/16/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request+Spread.h"


@interface CameraManager : NSObject

@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, strong) Request *request; // Optional payload to indicate it's a request submit.

- (void)presentImagePickerInViewController:(UIViewController *)controller;
+ (CameraManager *)sharedManager;

@end
