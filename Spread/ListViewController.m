//
//  FeedViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "ListViewController.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "ServiceManager.h"



@implementation ListViewController

@synthesize tableView;


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
	NSString* reuseIdentifier = @"PhotoCellIdentifier";
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	}

    Photo* photo = [[ServiceManager allPhotos] objectAtIndex:indexPath.row];
	cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.photoDescription;
    [cell.imageView setImageWithURL:[NSURL URLWithString:photo.imageURLString]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];

	return cell;
}



@end
