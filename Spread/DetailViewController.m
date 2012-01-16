//
//  DetailViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/15/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"



@interface DetailViewController ()
- (void)setImage:(UIImage*)image;
@end



@implementation DetailViewController

@synthesize activityIndicator;
@synthesize scrollView;
@synthesize closebutton;
@synthesize photo;



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.maximumZoomScale = 2.0;
    
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

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self setImage:image];
}

- (void)setImage:(UIImage*)image
{
    [self.activityIndicator stopAnimating];    

    [scrollView displayImage:image];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setClosebutton:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}


- (IBAction)closeButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)tapHandler:(UITapGestureRecognizer*)recognizer
{
    [UIView animateWithDuration:0.3 animations:^(void){
       
    }];
}

@end
