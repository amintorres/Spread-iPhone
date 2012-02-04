//
//  GridViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "GridViewController.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "User+Spread.h"
#import "MasterViewController.h"

#define kNumberOfColumns    3


@interface GridViewController ()
- (void)updateUserInfo;
@end


@implementation GridViewController

@synthesize headerView;
@synthesize footerView;
@synthesize noPhotoView;
@synthesize avatarImageView;
@synthesize nameLabel;
@synthesize numberOfPhotosLabel;
@synthesize nibLoadedCell;
@synthesize photoType;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = headerView;
    
    [self reloadTableView];    
    [self updateUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpreadDidLoadUserInfoNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        [self updateUserInfo];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self updateUserInfo];
}

- (void)viewDidUnload
{
    self.headerView = nil;
    self.footerView = nil;
    self.avatarImageView = nil;
    self.nameLabel = nil;
    self.numberOfPhotosLabel = nil;
    [self setNibLoadedCell:nil];
    [self setNoPhotoView:nil];
    [super viewDidUnload];
}

- (void)reloadTableView
{
    [super reloadTableView];
    
    int count = [[ServiceManager photosOfType:self.photoType] count];
    self.tableView.tableHeaderView = (count) ? self.headerView : self.noPhotoView;
    self.tableView.tableFooterView = (count) ? self.footerView : nil;
    self.tableView.scrollEnabled = (count);
}


#pragma mark -
#pragma mark User Info

- (void)updateUserInfo
{
    User* currentUser = [User currentUser];
    [avatarImageView setImageWithURL:currentUser.avatarURL];
    nameLabel.text = currentUser.name;
    
    NSInteger photoCount = [Photo count:nil];
    numberOfPhotosLabel.text = [NSString stringWithFormat:@"%d", photoCount];
}
     
     
#pragma mark -
#pragma mark TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    float count = (float)[[ServiceManager photosOfType:self.photoType] count] / kNumberOfColumns;
    return ceilf(count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"GridTableViewCell";
    
    GridTableViewCell* cell = (GridTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
    {
        UINib* nib = [UINib nibWithNibName:@"GridTableViewCell" bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        
        cell = nibLoadedCell;
        self.nibLoadedCell = nil;
	}

    NSInteger loc = indexPath.row * kNumberOfColumns;
    NSInteger len = MIN( [[ServiceManager photosOfType:self.photoType] count] - loc, kNumberOfColumns );
    NSRange range = NSMakeRange(loc, len);
    NSArray* photos = [[ServiceManager photosOfType:self.photoType] subarrayWithRange:range];
    cell.photos = photos;
    
    return cell;
}


#pragma mark -
#pragma mark Table View Delegate



@end
