//
//  PhotosViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotosCollectionViewController.h"
#import "PhotosTableViewController.h"
#import "UploadViewController.h"
#import "EditViewController.h"
#import "ReviewViewController.h"


@interface PhotosViewController () <UploadViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UIButton *displayModeButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) PhotosCollectionViewController *collectionViewController;
@property (nonatomic, strong) PhotosTableViewController *tableViewController;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UploadViewController *uploadViewController;
@end



@implementation PhotosViewController 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PhotosViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self displayNumberOfPhotos];
    [self reloadData];
    
    self.uploadViewController = [UploadViewController new];
    self.uploadViewController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displayCollectionView];
    
    [self.uploadViewController update];
}

- (void)reloadData
{
    // Default implementation does nothing.
}


#pragma mark - Upload View Controller

- (void)shouldShowUploadViewController:(UploadViewController *)controller
{
    if (!self.uploadViewController.view.superview)
    {
        self.uploadViewController.view.frame = self.headerView.bounds;
        [self.headerView addSubview:self.uploadViewController.view];
        self.uploadViewController.view.alpha = 1.0;
    }
}

- (void)shouldHideUploadViewController:(UploadViewController *)controller
{
    if (self.uploadViewController.view.superview)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.uploadViewController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.uploadViewController.view removeFromSuperview];
        }];
    }
    
    [self reloadData];
}


#pragma mark - IBAction

- (IBAction)displayModeButtonTapped:(id)sender
{
    if (self.tableView.superview)
    {
        [self.displayModeButton setImage:[UIImage imageNamed:@"icon-blue-list"] forState:UIControlStateNormal];
        [self displayCollectionView];
    }
    else
    {
        [self.displayModeButton setImage:[UIImage imageNamed:@"icon-blue-grid"] forState:UIControlStateNormal];
        [self displayTableView];
    }
}

- (IBAction)sumbitButtonTapped:(id)sender
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

#pragma mark - UIActionSheet Delegate

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


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
    {
        EditViewController* editViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"EditViewController"];
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


#pragma mark - Photos

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    self.collectionViewController.photos = photos;
    self.tableViewController.photos = photos;
    [self displayNumberOfPhotos];
}

- (void)displayNumberOfPhotos
{
    self.numberOfPhotosLabel.text = [NSString stringWithFormat:@"Photos:\n(%d)", [self.photos count]];
}


#pragma mark - CollectionView / TableView

- (void)displayCollectionView
{
    [self.tableView removeFromSuperview];
    
    self.collectionViewController.photos = self.photos;
    self.collectionView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.collectionView];
}

- (void)displayTableView
{
    [self.collectionView removeFromSuperview];
    
    self.tableViewController.photos = self.photos;
    self.tableView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.tableView];
}


#pragma mark -

- (PhotosCollectionViewController *)collectionViewController
{
    if (!_collectionViewController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _collectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotosCollectionViewController"];
    }
    return _collectionViewController;
}

- (PhotosTableViewController *)tableViewController
{
    if (!_tableViewController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _tableViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotosTableViewController"];
    }
    return _tableViewController;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = self.collectionViewController.collectionView;
    }
    return _collectionView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = self.tableViewController.tableView;
    }
    return _tableView;
}


@end
