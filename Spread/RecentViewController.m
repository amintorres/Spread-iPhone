//
//  RecentViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "RecentViewController.h"
#import "FourImagesCell.h"
#import "ServiceManager.h"



@interface RecentViewController ()

@property (nonatomic, strong) NSArray* photos;

@end



@implementation RecentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalPhotosLabel.text = [NSString stringWithFormat:@"Photos:\n(%d)", [self.photos count]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[ServiceManager sharedManager] loadRecentPhotosWithHandler:^(id response, BOOL success, NSError *error) {
       
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photos = response;
                self.totalPhotosLabel.text = [NSString stringWithFormat:@"Photos:\n(%d)", [self.photos count]];
                [self.tableView reloadData];
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil( (float)[self.photos count] / 4 );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FourImagesCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FourImagesCell"];
    
    NSUInteger start = indexPath.row * 4;
    NSUInteger end = MIN(start + 4, [self.photos count]);
    cell.photos = [self.photos subarrayWithRange:NSMakeRange(start, end - start)];
    
    return cell;
}

@end
