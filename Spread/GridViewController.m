//
//  GridViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "GridViewController.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "ServiceManager.h"



@implementation GridViewController

@synthesize gridView;
@synthesize headerView;
@synthesize footerView;


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
    gridView.showsVerticalScrollIndicator = NO;
    
    UIView* backgroundView = [[UIView alloc] init];
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
    [super viewDidUnload];
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
        cell = [[AQGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 80, 80) reuseIdentifier:cellIdentifier];
        cell.selectionGlowColor = [UIColor blueColor];
        
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


@end
