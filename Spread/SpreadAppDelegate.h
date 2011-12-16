//
//  SpreadAppDelegate.h
//  Spread
//
//  Created by Amin Torres on 12/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpreadViewController;

@interface SpreadAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SpreadViewController *viewController;

@end
