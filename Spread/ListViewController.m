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

@synthesize tableView;
@synthesize nibLoadedCell;


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ServiceManagerDidLoadPhotosNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
       
        [tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
}

- (void)viewDidUnload
{
    self.tableView = nil;
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
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}



@end
