//
//  UploadViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/9/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "UploadViewController.h"
#import "ServiceManager.h"

#define kProgressForUpload  0.6


@interface UploadViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *reloadButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@end


@implementation UploadViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressChanged:) name:SpreadNotificationUploadProgressChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFinished:) name:SpreadNotificationUploadFinished object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)update
{
    if ([ServiceManager sharedManager].uploadQueue.count)
    {
        [self.delegate shouldShowUploadViewController:self];
        
        ConnectionHelper *helper = [[ServiceManager sharedManager].uploadQueue lastObject];
        
        if (helper.error)
        {
            self.progressView.hidden = YES;
            self.thumbImageView.hidden = NO;
            self.textLabel.hidden = NO;
            self.reloadButton.hidden = NO;
            self.closeButton.hidden = NO;
        }
        else
        {
            self.progressView.hidden = NO;
            self.thumbImageView.hidden = YES;
            self.textLabel.hidden = YES;
            self.reloadButton.hidden = YES;
            self.closeButton.hidden = YES;

            float progress = kProgressForUpload * helper.uploadProgress;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.progressView.progress = progress;
            } completion:NULL];
//            [self.progressView setProgress:progress animated:YES];
        }
    }
    else
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.progressView.progress = 1.0;
        } completion:^(BOOL finished) {
            [self.delegate shouldHideUploadViewController:self];
        }];
    }
}

- (void)progressChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self update];
    });
}

- (void)uploadFinished:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self update];
    });
}

- (IBAction)reloadButtonTapped:(id)sender
{
    ConnectionHelper *helper = [[ServiceManager sharedManager].uploadQueue lastObject];
    [[ServiceManager sharedManager] sendPostRequest:helper.connection.originalRequest completionHandler:NULL];
    [self update];
}

- (IBAction)closeButtonTapped:(id)sender
{
    [[ServiceManager sharedManager].uploadQueue removeLastObject];
    [self update];
}



@end
