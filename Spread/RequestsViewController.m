//
//  RequestsViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/4/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "RequestsViewController.h"
#import "RequestCell.h"



@interface RequestsViewController ()

@property (nonatomic, strong) NSArray* requests;

@end



@implementation RequestsViewController
@synthesize totalRequestsLabel;
@synthesize totalPriceLabel;
@synthesize tableView;
@synthesize requests;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    return [self.requests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    return cell;
}

@end
