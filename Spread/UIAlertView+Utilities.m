//
//  UIAlertView+Utilities.m
//  Spread
//
//  Created by Joseph Lin on 1/26/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "UIAlertView+Utilities.h"



@implementation UIAlertView (Utilities)


+ (UIAlertView*)showAlertWithError:(NSError*)error
{
    NSString* message = nil;
    
    if ( [error code] == RKRequestBaseURLOfflineError )
    {
        message = @"Cannot connect to the server. Please check your connection.";
    }

    if ( message )
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        
        return alert;
    }
    else
    {
        return nil;
    }
}


@end
