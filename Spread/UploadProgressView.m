//
//  UploadProgressView.m
//  Spread
//
//  Created by Joseph Lin on 1/24/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UploadProgressView.h"
#import "ServiceManager.h"



@implementation UploadProgressView

@synthesize progressView, textLabel, retryButton;
@synthesize activityIndicator;
@synthesize object;


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 3.0;
}

- (void)setObject:(id)theObject
{
    object = theObject;
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    if ( self.object )
    {
        [center addObserver:self selector:@selector(didSendPhotoBodyData:) name:SpreadDidSendPhotoBodyDataNotification object:self.object];
        [center addObserver:self selector:@selector(didFinishSendingPhoto:) name:SpreadDidFinishSendingPhotoNotification object:self.object];
        [center addObserver:self selector:@selector(didFailSendingPhoto:) name:SpreadDidFailSendingPhotoNotification object:self.object];
    }
}

- (void)startSending
{
    dispatch_async(dispatch_get_main_queue(), ^{

        self.hidden = NO;
        self.alpha = 1.0;
        
        self.progressView.hidden = NO;
        self.progressView.progress = 0.0;
        
        self.textLabel.hidden = YES;
        
        self.retryButton.hidden = YES;
        
        [self.activityIndicator stopAnimating];
    });
}

- (void)didSendPhotoBodyData:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary* userInfo = notification.userInfo;
        NSNumber* totalBytesWritten = [userInfo objectForKey:@"totalBytesWritten"];
        NSNumber* totalBytesExpectedToWrite = [userInfo objectForKey:@"totalBytesExpectedToWrite"];
        
        float progress = [totalBytesWritten floatValue] / [totalBytesExpectedToWrite floatValue];
        
        if ( progress < 1.0 )
        {
            [self.progressView setProgress:progress animated:YES];
        }
        else
        {
            //// There's latency between 'request sent' and 'response receive'.
            
            self.progressView.hidden = YES;
            
            self.textLabel.hidden = NO;
            self.textLabel.text = @"Processing...";
            self.textLabel.textColor = [UIColor whiteColor];
        
            [self.activityIndicator startAnimating];
        }
    });
}

- (void)didFinishSendingPhoto:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.progressView.hidden = YES;
        
        self.textLabel.hidden = NO;
        self.textLabel.text = @"Photo sent!";
        self.textLabel.textColor = [UIColor whiteColor];
        
        [self.activityIndicator stopAnimating];
        
        [UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            
            self.alpha = 0.0;
            
        } completion:^(BOOL finished){
            
            self.hidden = YES;
            self.object = nil;
        }];
    });
}

- (void)didFailSendingPhoto:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.textLabel.hidden = YES;
        self.textLabel.text = @"Upload failed!";
        self.textLabel.textColor = [UIColor redColor];
        
        self.retryButton.hidden = NO;
        
        [self.activityIndicator stopAnimating];
    });
}

- (IBAction)retryButtonTapped:(id)sender
{
    if ( [object isKindOfClass:[RKObjectLoader class]] )
    {
        [(RKObjectLoader*)sender sendAsynchronously];
    }
}



@end
