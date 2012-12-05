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
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) UITableView *tableView;

@end



@implementation PhotosViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self displayNumberOfPhotos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displayTableView];
}

- (IBAction)displayModeButtonTapped:(id)sender
{
    if (self.tableView.superview)
    {
        [self displayCollectionView];
    }
    else
    {
        [self displayTableView];
    }
}

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

- (PhotosCollectionViewController *)collectionViewController
{
    return nil;
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
    return self.collectionViewController.collectionView;
}

- (UITableView *)tableView
{
    return self.tableViewController.tableView;
}


@end
