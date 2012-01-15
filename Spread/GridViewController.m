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
#import "ServiceManager.h"
#import "User+Spread.h"



@interface GridViewController ()
- (void)updateUserInfo;
@end


@implementation GridViewController

@synthesize gridView;
@synthesize headerView;
@synthesize footerView;
@synthesize avatarImageView;
@synthesize nameLabel;
@synthesize numberOfPhotosLabel;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ServiceManagerDidLoadPhotosNotification object:nil queue:nil usingBlock:^(NSNotification* notification){
        
        [gridView reloadData];
    }];
    
    gridView.gridHeaderView = headerView;
    gridView.gridFooterView = footerView;
    gridView.leftContentInset = 6.0;
    gridView.rightContentInset = 6.0;
    gridView.showsVerticalScrollIndicator = NO;
    
    CGSize currentContentSize = gridView.contentSize;
    gridView.contentSize = CGSizeMake(300, currentContentSize.height);
    
    [self updateUserInfo];
    
    UIView* backgroundView = [[UIView alloc] init];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    backgroundView.backgroundColor = [UIColor whiteColor];
    gridView.backgroundView = backgroundView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [gridView reloadData];
}

- (void)viewDidUnload
{
    self.gridView = nil;
    self.headerView = nil;
    self.footerView = nil;
    self.avatarImageView = nil;
    self.nameLabel = nil;
    self.numberOfPhotosLabel = nil;
    [super viewDidUnload];
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
#pragma mark Grid View Data Source

- (NSUInteger)numberOfItemsInGridView:(AQGridView*)aGridView
{
    return [[ServiceManager allPhotos] count];
}

- (AQGridViewCell*)gridView:(AQGridView*)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString* cellIdentifier = @"CellIdentifier";
    
    AQGridViewCell* cell = [aGridView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( cell == nil )
    {
        cell = [[AQGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 88, 88) reuseIdentifier:cellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleGray;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = 123;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }
    
    Photo* photo = [[ServiceManager allPhotos] objectAtIndex:index];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:123];
    [imageView setImageWithURL:[NSURL URLWithString:photo.gridImageURLString]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];

    return cell;
}


#pragma mark -
#pragma mark Grid View Delegate

- (void)gridView:(AQGridView*)gridView didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"Did select item at index: %d", index);
}


@end
