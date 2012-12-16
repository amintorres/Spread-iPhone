//
//  PhotosTableViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/5/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FeedCell.h"
#import "Photo.h"
#import "EditViewController.h"


@interface PhotosTableViewController () <FeedCellDelegate>

@end


@implementation PhotosTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma mark - Table view delegate

- (void)editPhoto:(Photo *)photo atFeedCell:(FeedCell *)cell
{
    EditViewController* controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"EditViewController"];
    controller.photo = photo;
    controller.editMode = EditModeUpdate;
    
    [self presentViewController:controller animated:YES completion:NULL];
}

@end
