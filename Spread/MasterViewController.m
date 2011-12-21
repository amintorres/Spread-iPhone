//
//  MasterViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "MasterViewController.h"
#import "ServiceManager.h"


typedef enum{
    ContainerViewModeIntro = 0,
    ContainerViewModeList,
    ContainerViewModeGrid
} ContainerViewMode;



@interface MasterViewController ()

@property (strong, nonatomic) IntroViewController* introViewController;
@property (strong, nonatomic) ListViewController* listViewController;
@property (strong, nonatomic) GridViewController* gridViewController;
@property (nonatomic) ContainerViewMode containerViewMode;

- (void)showIntroView;

@end



@implementation MasterViewController

@synthesize headerView, containerView, toolbarView;
@synthesize gridListButton;
@synthesize introViewController, listViewController, gridViewController;
@synthesize containerViewMode;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showIntroView];
}

- (void)viewDidUnload
{
    self.headerView = nil;
    self.containerView = nil;
    self.toolbarView = nil;
    self.gridListButton = nil;
    [super viewDidUnload];
}

- (IntroViewController*)introViewController
{
    if ( !introViewController )
    {
        self.introViewController = [[IntroViewController alloc] init];
        introViewController.delegate = self;
    }
    return introViewController;
}

- (GridViewController*)gridViewController
{
    if ( !gridViewController )
    {
        self.gridViewController = [[GridViewController alloc] init];
    }
    return gridViewController;
}

- (ListViewController*)listViewController
{
    if ( !listViewController )
    {
        self.listViewController = [[ListViewController alloc] init];
    }
    return listViewController;
}

- (void)clearContainerView
{
    for ( UIView* subview in containerView.subviews )
    {
        [subview removeFromSuperview];
    }    
}

- (void)showGridView
{
    [self clearContainerView];
    
    [containerView addSubview:self.gridViewController.view];
    [gridListButton setTitle:@"List" forState:UIControlStateNormal];
    
    containerViewMode = ContainerViewModeGrid;
}

- (void)showListView
{
    [self clearContainerView];
    
    [containerView addSubview:self.listViewController.view];
    [gridListButton setTitle:@"Grid" forState:UIControlStateNormal];
    
    containerViewMode = ContainerViewModeList;
}

- (void)showIntroView
{
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{

                        [self.view addSubview:self.introViewController.view];
                    }
                    completion:NULL]; 
    
    containerViewMode = ContainerViewModeIntro;
}

- (void)hideIntroView
{
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        [self.introViewController.view removeFromSuperview];
                    }
                    completion:NULL];
    
    [ServiceManager loadDataFromServer];
    [self showListView];
}


#pragma mark -
#pragma mark IBAction

- (IBAction)gridListButtonTapped:(id)sender
{
    if ( containerViewMode == ContainerViewModeList )
    {
        [self showGridView];        
    }
    else if ( containerViewMode == ContainerViewModeGrid )
    {
        [self showListView];
    }
}

- (IBAction)cameraButtonTapped:(id)sender
{
}

- (IBAction)logoutButtonTapped:(id)sender
{
    [self showIntroView];
}

- (void)introViewControllerDidLogin:(IntroViewController*)controller
{
    [self hideIntroView];
}


@end
