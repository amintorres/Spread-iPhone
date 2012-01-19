//
//  FeedViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ListViewController.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "ServiceManager.h"
#import "MasterViewController.h"



@implementation ListViewController

@synthesize nibLoadedCell;


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    self.nibLoadedCell = nil;
    [super viewDidUnload];
}


#pragma mark -
#pragma mark TableView

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [[ServiceManager allPhotos] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* reuseIdentifier = @"ListTableViewCell";
	ListTableViewCell* cell = (ListTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell)
    {
        UINib* nib = [UINib nibWithNibName:@"ListTableViewCell" bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        
        cell = nibLoadedCell;
        self.nibLoadedCell = nil;
	}

    cell.photo = [[ServiceManager allPhotos] objectAtIndex:indexPath.row];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Photo* photo = [[ServiceManager allPhotos] objectAtIndex:indexPath.row];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:photo forKey:@"photo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SpreadDidSelectPhotoNotification object:self userInfo:userInfo];
}


#pragma mark -

- (void)scrollToPhoto:(Photo*)photo
{
    NSInteger index = [[ServiceManager allPhotos] indexOfObject:photo];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (UIImageView*)imageViewForPhoto:(Photo*)photo
{
    NSInteger index = [[ServiceManager allPhotos] indexOfObject:photo];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ListTableViewCell* cell = (ListTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    return cell.imageView;
}


@end
