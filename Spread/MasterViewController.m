//
//  MasterViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "MasterViewController.h"
#import "ServiceManager.h"
#import "IntroViewController.h"
#import "EditViewController.h"
#import "AboutViewController.h"
#import "UINavigationBar+Customize.h"

NSString * const SpreadShouldLogoutNotification = @"SpreadShouldLogoutNotification";
NSString * const SpreadShouldEditPhotoNotification = @"SpreadShouldEditPhotoNotification";

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
- (void)hideIntroView;
- (void)editPhoto:(Photo*)photo;

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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidLoginNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        [self hideIntroView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadShouldLogoutNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        [self showIntroView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadShouldEditPhotoNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        Photo* photo = [notification.userInfo objectForKey:@"photo"];
        [self editPhoto:photo];
    }];

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


#pragma mark -
#pragma mark Accessors

- (IntroViewController*)introViewController
{
    if ( !introViewController )
    {
        self.introViewController = [[IntroViewController alloc] init];
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


#pragma mark -
#pragma mark View Management

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
    
    gridViewController.view.frame = containerView.bounds;
    [containerView addSubview:self.gridViewController.view];
    [gridListButton setImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
    
    containerViewMode = ContainerViewModeGrid;
}

- (void)showListView
{
    [self clearContainerView];
    
    listViewController.view.frame = containerView.bounds;
    [containerView addSubview:self.listViewController.view];
    [gridListButton setImage:[UIImage imageNamed:@"icon_grid"] forState:UIControlStateNormal];
    
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
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];

    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] )
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        return;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)aboutButtonTapped:(id)sender
{
    AboutViewController* aboutViewController = [[AboutViewController alloc] init];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    [navController.navigationBar customizeBackground];
    [self presentModalViewController:navController animated:YES];
}

- (void)editPhoto:(Photo*)photo
{
    EditViewController* editViewController = [[EditViewController alloc] init];
    editViewController.photo = photo;
    editViewController.editMode = EditModeUpdate;
    [self presentModalViewController:editViewController animated:YES];
}


#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    EditViewController* editViewController = [[EditViewController alloc] init];
    editViewController.mediaInfo = info;
    editViewController.editMode = EditModeCreate;
    [picker pushViewController:editViewController animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];    
}



@end



