//
//  AppDelegate.m
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "TestFlight.h"
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Photo.h"
#import "SpreadAPIDefinition.h"
#import "UINavigationBar+Customize.h"
#import "ServiceManager.h"



@implementation AppDelegate

@synthesize window;
@synthesize navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ServiceManager setupRestKit];
    
    [TestFlight takeOff:@"f319601b6e6c25b7c3f258bcdaa9e768_NTI4NDQyMDEyLTAxLTExIDEwOjU2OjEzLjE1NDkxNQ"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.navigationController.navigationBarHidden = YES;
    [navigationController.navigationBar customizeBackground];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
