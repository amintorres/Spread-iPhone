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

@property (strong, nonatomic) UIImageView* transientImageView;
- (void)setImage:(UIImage*)image;
- (void)layoutInfoView;
- (void)showNavView;
- (void)hideNavView;
@end



@implementation DetailViewController

@synthesize activityIndicator;
@synthesize imageScrollView;
@synthesize navView;
@synthesize overlayView;
@synthesize infoScrollView, infoView, titleLabel, divider, descriptionLabel, closebutton;
@synthesize photo;
@synthesize originFrame;
@synthesize transientImageView;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [navView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return ( toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown );
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft )
    {
        self.transientImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
        self.transientImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    else if ( toInterfaceOrientation == UIInterfaceOrientationPortrait )
    {
        self.transientImageView.transform = CGAffineTransformIdentity;
    }

    [self layoutInfoView];
}


#pragma mark -
#pragma mark Transition Animation

- (UIImageView*)transientImageView
{
    if ( !transientImageView )
    {
        transientImageView = [[UIImageView alloc] init];
        transientImageView.clipsToBounds = YES;
        transientImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return transientImageView;
}

- (void)setupTransientImageView
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL* feedImageURL = [NSURL URLWithString:self.photo.feedImageURLString];
    UIImage *cachedFeedImage = [manager imageWithURL:feedImageURL];
    
    //// Master view should ensure the feed image is already loaded. ////
    if ( !cachedFeedImage )
        return;
    
    
    self.imageScrollView.alpha = 0.0;
    
    CGRect convertedFrame = [self.view convertRect:originFrame fromView:nil];
    self.transientImageView.frame = convertedFrame;
    self.transientImageView.image = cachedFeedImage;
    [self.view insertSubview:self.transientImageView aboveSubview:self.imageScrollView];
}

- (void)animateImageIntoPlace
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL* feedImageURL = [NSURL URLWithString:self.photo.feedImageURLString];
    UIImage *cachedFeedImage = [manager imageWithURL:feedImageURL];
    [self.imageScrollView displayImage:cachedFeedImage];

    CGRect convertedFrame = [self.view convertRect:originFrame fromView:nil];
    self.transientImageView.frame = convertedFrame;
    CGRect targetFrame = [self.imageScrollView convertRect:self.imageScrollView.imageView.frame toView:self.view];
    
    [UIView animateWithDuration:0.3 animations:^(void){
        
        self.transientImageView.transform = CGAffineTransformIdentity;
        self.transientImageView.frame = targetFrame;
        
    } completion:^(BOOL finished){
        
        self.imageScrollView.alpha = 1.0;
        [self.transientImageView removeFromSuperview];
        
        [self showNavView];
    }];
}

- (void)animateImageBackToOriginalPlace
{
    [self hideNavView];
    
    CGRect targetFrame = [self.imageScrollView convertRect:self.imageScrollView.imageView.frame toView:self.view];
    self.transientImageView.frame = targetFrame;
    self.transientImageView.image = self.imageScrollView.imageView.image;
    self.transientImageView.transform = CGAffineTransformIdentity;
    [self.view insertSubview:self.transientImageView aboveSubview:self.imageScrollView];
    
    self.imageScrollView.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^(void){
        
        CGRect convertedFrame = [self.view convertRect:self.originFrame fromView:nil];
        self.transientImageView.frame = convertedFrame;
        
        if ( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft )
        {
            self.transientImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        else if ( self.interfaceOrientation == UIInterfaceOrientationLandscapeRight )
        {
            self.transientImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        else if ( self.interfaceOrientation == UIInterfaceOrientationPortrait )
        {
            self.transientImageView.transform = CGAffineTransformIdentity;
        }
        
    } completion:^(BOOL finished){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidDeselectPhotoNotification object:self];
    }];
}


#pragma mark -
#pragma mark Image View

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
    self.overlayView.frame = self.view.bounds;
    
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
        [navView setWidth:self.view.bounds.size.width];
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
    [self animateImageBackToOriginalPlace];
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
