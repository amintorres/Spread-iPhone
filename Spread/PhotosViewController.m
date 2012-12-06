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



@interface PhotosViewController ()
@property (nonatomic, strong) IBOutlet UIButton *displayModeButton;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) PhotosCollectionViewController *collectionViewController;
@property (nonatomic, strong) PhotosTableViewController *tableViewController;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displayCollectionView];
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
