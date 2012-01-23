//
//  MasterViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/14/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "MasterViewController.h"
#import "ServiceManager.h"
#import "IntroViewController.h"
#import "ReviewViewController.h"
#import "EditViewController.h"
#import "AboutViewController.h"
#import "DetailViewController.h"
#import "UINavigationBar+Customize.h"
#import "User+Spread.h"

NSString * const SpreadShouldLogoutNotification = @"SpreadShouldLogoutNotification";
NSString * const SpreadShouldEditPhotoNotification = @"SpreadShouldEditPhotoNotification";
NSString * const SpreadDidSelectPhotoNotification = @"SpreadDidSelectPhotoNotification";
NSString * const SpreadDidDeselectPhotoNotification = @"SpreadDidDeselectPhotoNotification";

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
- (void)showListView;
- (void)showGridView;
- (void)showWelcomeView;
- (void)editPhoto:(Photo*)photo;
- (void)showDetailViewForPhoto:(Photo*)photo;
- (void)hideDetailView;

@end



@implementation MasterViewController

@synthesize navigationBar, containerView, toolbarView;
@synthesize gridListButton;
@synthesize cameraOverlayView;
@synthesize welcomeView;
@synthesize welcomeLabel;
@synthesize introViewController, listViewController, gridViewController;
@synthesize containerViewMode;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar customizeBackground];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidLoginNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        [self hideIntroView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadShouldLogoutNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        [self showIntroView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidLoadPhotosNotification object:nil queue:nil usingBlock:^(NSNotification* notification){

        if ( [[ServiceManager allPhotos] count] )
        {
            [self showListView];
        }
        else
        {
            [self showWelcomeView];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadShouldEditPhotoNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        Photo* photo = [notification.userInfo objectForKey:@"photo"];
        [self editPhoto:photo];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidSelectPhotoNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        Photo* photo = [notification.userInfo objectForKey:@"photo"];
        if ( notification.object == listViewController )
        {
            [self showDetailViewForPhoto:photo];
        }
        else
        {
            [self showListView];
            [self.listViewController scrollToPhoto:photo];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidDeselectPhotoNotification object:nil queue:nil usingBlock:^(NSNotification* notification){

        [self hideDetailView];
    }];

    if ( [ServiceManager isSessionValid] )
    {
        [self hideIntroView];
    }
    else
    {
        [self showIntroView];        
    }
}

- (void)viewDidUnload
{
    self.navigationBar = nil;
    self.containerView = nil;
    self.toolbarView = nil;
    self.gridListButton = nil;
    self.cameraOverlayView = nil;
    [self setWelcomeView:nil];
    [self setWelcomeLabel:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark Accessors

- (IntroViewController*)introViewController
{
    if ( !introViewController )
    {
        introViewController = [[IntroViewController alloc] init];
    }
    return introViewController;
}

- (GridViewController*)gridViewController
{
    if ( !gridViewController )
    {
        gridViewController = [[GridViewController alloc] init];
    }
    return gridViewController;
}

- (ListViewController*)listViewController
{
    if ( !listViewController )
    {
        listViewController = [[ListViewController alloc] init];
    }
    return listViewController;
}


#pragma mark -
#pragma mark View Management

- (void)clearContainerView
{
    for ( UIView* subview in self.containerView.subviews )
    {
        [subview removeFromSuperview];
    }    
}

- (void)showGridView
{
    [self clearContainerView];
    
    self.gridViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.gridViewController.view];
    [self.gridListButton setImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
    self.gridListButton.enabled = YES;
    
    self.containerViewMode = ContainerViewModeGrid;
}

- (void)showListView
{
    [self clearContainerView];
    
    self.listViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.listViewController.view];
    [self.gridListButton setImage:[UIImage imageNamed:@"icon_grid"] forState:UIControlStateNormal];
    self.gridListButton.enabled = YES;
    
    self.containerViewMode = ContainerViewModeList;
}

- (void)showWelcomeView
{
    [self clearContainerView];
    
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@.\nWe look forward to all the great moments you'll capture!", [User currentUser].name];
    
    [self.containerView addSubview:self.welcomeView];
    self.gridListButton.enabled = NO;
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
    
    self.containerViewMode = ContainerViewModeIntro;
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
    [ServiceManager loadUserInfoFromServer];
    [self showListView];
}

- (void)showDetailViewForPhoto:(Photo*)photo
{    
    UIImageView* imageView = [self.listViewController imageViewForPhoto:photo];
    
    if ( !imageView.image )
    {
        //// Only show detail view when feed image is available. ///
        return;
    }
    
    
    CGRect windowFrame = [imageView.superview convertRect:imageView.frame toView:nil];

    DetailViewController* detailViewController = [[DetailViewController alloc] init];
    detailViewController.photo = photo;
    detailViewController.originFrame = windowFrame;
    
    detailViewController.view.alpha = 0.0;
    CGRect frame = [self.view convertRect:detailViewController.view.frame fromView:nil];
    [self.view addSubview:detailViewController.view];
    detailViewController.view.frame = frame;
    
    [detailViewController setupTransientImageView];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [UIView animateWithDuration:0.3 animations:^(void){

        detailViewController.view.alpha = 1.0;
        
    } completion:^(BOOL finished){
       
        [self presentModalViewController:detailViewController animated:NO];
        [detailViewController animateImageIntoPlace];
    }];    
}

- (void)hideDetailView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    UIViewController* detailViewController = self.modalViewController;
    [self dismissModalViewControllerAnimated:NO];
    
    CGRect frame = [self.view convertRect:detailViewController.view.frame fromView:nil];
    [self.view addSubview:detailViewController.view];
    detailViewController.view.frame = frame;
    detailViewController.view.alpha = 1.0;

    [UIView animateWithDuration:0.3 animations:^(void){
        
        detailViewController.view.alpha = 0.0;
        
    } completion:^(BOOL finished){
        
        [detailViewController.view removeFromSuperview];

    }]; 
}


#pragma mark -
#pragma mark IBAction

- (IBAction)gridListButtonTapped:(id)sender
{
    if ( self.containerViewMode == ContainerViewModeList )
    {
        [self showGridView];        
    }
    else if ( self.containerViewMode == ContainerViewModeGrid )
    {
        [self showListView];
    }
}

- (IBAction)cameraButtonTapped:(id)sender
{
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIActionSheet* action  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        [action showInView:self.view];
    }
    else
    {
        UIActionSheet* action  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", nil];
        [action showInView:self.view];        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == actionSheet.cancelButtonIndex )
    {
        return;
    }


    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && buttonIndex == actionSheet.firstOtherButtonIndex )
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
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

- (IBAction)albumButtonTapped:(id)sender
{
}


#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
    {
        EditViewController* editViewController = [[EditViewController alloc] init];
        editViewController.mediaInfo = info;
        editViewController.editMode = EditModeCreate;
        [picker pushViewController:editViewController animated:YES];
    }
    else
    {
        ReviewViewController* reviewViewController = [[ReviewViewController alloc] init];
        reviewViewController.mediaInfo = info;
        [picker pushViewController:reviewViewController animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];    
}



@end



