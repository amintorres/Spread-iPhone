//
//  PhotosViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "PhotosViewController.h"
#import "UploadViewController.h"
#import "EditViewController.h"
#import "FlagViewController.h"
#import "CameraManager.h"
#import "ThumbCell.h"
#import "FeedCell.h"

#define kAnimationDuration 0.2



@interface PhotosViewController () <UploadViewControllerDelegate, FeedCellDelegate>
@property (nonatomic, strong) IBOutlet UIButton *displayModeButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
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
    
    UINib *thumbCellNib = [UINib nibWithNibName:@"ThumbCell" bundle:nil];
    [self.collectionView registerNib:thumbCellNib forCellWithReuseIdentifier:@"ThumbCell"];

    UINib *feedCellNib = [UINib nibWithNibName:@"FeedCell" bundle:nil];
    [self.tableView registerNib:feedCellNib forCellReuseIdentifier:@"FeedCell"];

    [self displayNumberOfPhotos];
    [self reloadData];
    
    self.uploadViewController = [UploadViewController new];
    self.uploadViewController.delegate = self;

    [self displayCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.uploadViewController update];
    
    [self.collectionView reloadData];
    [self.tableView reloadData];

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
    
//    [self reloadData];
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
    [[CameraManager sharedManager] presentImagePickerInViewController:self];
}


#pragma mark - Photos

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self displayNumberOfPhotos];
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

- (void)displayNumberOfPhotos
{
    self.numberOfPhotosLabel.text = [NSString stringWithFormat:@"Photos:\n(%d)", [self.photos count]];
}


#pragma mark - Collection View

- (void)displayCollectionView
{
    if (![self.collectionView superview])
    {
        self.collectionView.frame = self.contentView.bounds;
        self.collectionView.alpha = 0.0;
        [self.contentView addSubview:self.collectionView];
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.collectionView.alpha = 1.0;
            self.tableView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.tableView removeFromSuperview];
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbCell" forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self displayTableView];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma mark - Table View

- (void)displayTableView
{
    if (![self.tableView superview])
    {
        self.tableView.frame = self.contentView.bounds;
        self.tableView.alpha = 0.0;
        [self.contentView addSubview:self.tableView];
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.tableView.alpha = 1.0;
            self.collectionView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.collectionView removeFromSuperview];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [FeedCell suggestedHeightForPhoto:self.photos[indexPath.row]];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - FeedCell delegate

- (void)editPhoto:(Photo *)photo atFeedCell:(FeedCell *)cell
{
    EditViewController* controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"EditViewController"];
    controller.photo = photo;
    controller.editMode = EditModeUpdate;
    
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)flagPhoto:(Photo *)photo atFeedCell:(FeedCell *)cell
{
    FlagViewController* controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FlagViewController"];
    controller.photo = photo;
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
