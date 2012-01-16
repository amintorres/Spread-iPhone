//
//  DetailViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Resizing.h"
#import "UIView+Shortcut.h"

#define kLabelSpacing   10.0



@interface DetailViewController ()
- (void)setImage:(UIImage*)image;
- (void)layoutInfoView;
@end



@implementation DetailViewController

@synthesize activityIndicator;
@synthesize imageScrollView;
@synthesize navView;
@synthesize overlayView;
@synthesize infoScrollView, infoView, titleLabel, divider, descriptionLabel, closebutton;
@synthesize photo;



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageScrollView.maximumZoomScale = 2.0;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL* URL = [NSURL URLWithString:self.photo.largeImageURLString];
    UIImage *cachedImage = [manager imageWithURL:URL];
    
    if (cachedImage)
    {
        [self setImage:cachedImage];
    }
    else
    {
        [self.activityIndicator startAnimating];
        [manager downloadWithURL:URL delegate:self];
    }
}

- (void)viewDidUnload
{
    [self setImageScrollView:nil];
    [self setClosebutton:nil];
    [self setActivityIndicator:nil];
    [self setNavView:nil];
    [self setOverlayView:nil];
    [self setInfoScrollView:nil];
    [self setInfoView:nil];
    [self setTitleLabel:nil];
    [self setDivider:nil];
    [self setDescriptionLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutInfoView];
}


#pragma mark -
#pragma mark Image View

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self setImage:image];
}

- (void)setImage:(UIImage*)image
{
    [self.activityIndicator stopAnimating];    
    
    [imageScrollView displayImage:image];
}


#pragma mark -
#pragma mark Info View

- (void)layoutInfoView
{
    titleLabel.text = photo.title;
    [titleLabel resizeToFitHeight];

    [divider setY:CGRectGetMaxY(titleLabel.frame) + kLabelSpacing];
    
    [descriptionLabel setY:CGRectGetMaxY(divider.frame) + kLabelSpacing];
    descriptionLabel.text = photo.photoDescription;
    [descriptionLabel resizeToFitHeight];

    CGFloat infoViewHeight = MAX(infoView.frame.size.height, CGRectGetMaxY(descriptionLabel.frame) + kLabelSpacing);
    [infoView setHeight:infoViewHeight];
    infoScrollView.contentSize = infoView.bounds.size;
}

- (void)showOverlayView
{
    if ( !overlayView.superview )
    {
        [self layoutInfoView];
        
        imageScrollView.userInteractionEnabled = NO;
        overlayView.alpha = 0.0;
        [self.view addSubview:overlayView];        
        
        [UIView animateWithDuration:0.5 animations:^(void){
         
            overlayView.alpha = 1.0;
        }];
    }
}

- (void)hideOverlayView
{
    if ( overlayView.superview )
    {
        [UIView animateWithDuration:0.5 animations:^(void){
            
            overlayView.alpha = 0.0;
            
        } completion:^(BOOL finished){
            
            [overlayView removeFromSuperview];
            imageScrollView.userInteractionEnabled = YES;
        }];
    }
}


#pragma mark -
#pragma mark Nav View

- (void)showNavView
{
    if ( !navView.superview )
    {
        navView.alpha = 0.0;
        [self.view addSubview:navView];
        
        [UIView animateWithDuration:0.3 animations:^(void){
            
            navView.alpha = 1.0;
        }];
    }
}

- (void)hideNavView
{
    if ( navView.superview )
    {
        [UIView animateWithDuration:0.3 animations:^(void){
            
            navView.alpha = 0.0;
            
        } completion:^(BOOL finished){
            
            [navView removeFromSuperview];
        }];
    }
}


#pragma mark -
#pragma mark IBAction

- (IBAction)backButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)infoButtonTapped:(id)sender
{
    [self showOverlayView];
}

- (IBAction)closeButtonTapped:(id)sender
{
    [self hideOverlayView];
}

- (IBAction)tapHandler:(UITapGestureRecognizer*)recognizer
{
    if ( navView.superview )
    {
        [self hideNavView];
    }
    else
    {
        [self showNavView];
    }
}

@end
