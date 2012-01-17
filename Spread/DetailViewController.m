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
#import "MasterViewController.h"

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

- (void)fadeInFromRect:(CGRect)rect
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL* feedImageURL = [NSURL URLWithString:self.photo.feedImageURLString];
    UIImage *cachedFeedImage = [manager imageWithURL:feedImageURL];

    //// Master view should ensure the feed image is already loaded. ////
    if ( !cachedFeedImage )
        return;
    
    [imageScrollView displayImage:cachedFeedImage];

    UIImageView* transientImageView = [[UIImageView alloc] initWithFrame:rect];
    transientImageView.clipsToBounds = YES;
    transientImageView.contentMode = UIViewContentModeScaleAspectFill;
    transientImageView.image = cachedFeedImage;
    [self.view addSubview:transientImageView];
    
    imageScrollView.alpha = 0.0;
    self.view.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^(void){
       
        self.view.alpha = 1.0;
        
    } completion:^(BOOL finished){
        
        
        [UIView animateWithDuration:0.3 animations:^(void){
            
            CGRect targetFrame = [imageScrollView convertRect:imageScrollView.imageView.frame toView:self.view];
            transientImageView.frame = targetFrame;
            
        } completion:^(BOOL finished){
            
            imageScrollView.alpha = 1.0;
            [transientImageView removeFromSuperview];            
        }];
    }];
}

- (void)fadeOutToRect:(CGRect)rect
{
    CGRect targetFrame = [imageScrollView convertRect:imageScrollView.imageView.frame toView:self.view];

    UIImageView* transientImageView = [[UIImageView alloc] initWithFrame:targetFrame];
    transientImageView.clipsToBounds = YES;
    transientImageView.contentMode = UIViewContentModeScaleAspectFill;
    transientImageView.image = imageScrollView.imageView.image;
    [self.view addSubview:transientImageView];
    
    imageScrollView.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^(void){
        
        transientImageView.frame = rect;
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.3 animations:^(void){

            self.view.alpha = 0.0;
            
        } completion:^(BOOL finished){

            [transientImageView removeFromSuperview];            
            [self.view removeFromSuperview];
        }];
    }];
}

- (void)loadFeedImageAndThenLargImage
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL* feedImageURL = [NSURL URLWithString:self.photo.feedImageURLString];
    UIImage *cachedFeedImage = [manager imageWithURL:feedImageURL];

    //// If the feed image is already loaded, show it first. ////
    if (cachedFeedImage)
    {
        [self setImage:cachedFeedImage];
    }
    
    //// Then load large image silently. ////
    NSURL* largeImageURL = [NSURL URLWithString:self.photo.largeImageURLString];
    UIImage *cachedLargeImage = [manager imageWithURL:largeImageURL];
    
    if (cachedLargeImage)
    {
        [self setImage:cachedLargeImage];
    }
    else
    {
        [self.activityIndicator startAnimating];
        [manager downloadWithURL:largeImageURL delegate:self];
    }
}


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
    [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidDeselectPhotoNotification object:self];
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
