//
//  RequestsViewController.m
//  Spread
//
//  Created by Joseph Lin on 8/4/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "RequestsViewController.h"
#import "RequestCell.h"
#import "ServiceManager.h"
#import "Request+Spread.h"
#import "NSNumber+Spread.h"



@interface RequestsViewController ()

@property (nonatomic, strong) NSArray* requests;

@end



@implementation RequestsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[ServiceManager sharedManager] loadRequestsWithHandler:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.requests = response;
                self.totalRequestsLabel.text = [NSString stringWithFormat:@"%d Requests", [self.requests count]];
                
                NSString* amountString = [[Request totalAmount] currencyString];
                self.totalPriceLabel.text = [NSString stringWithFormat:@"%@ up for grabs", amountString];
                [self.tableView reloadData];
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.requests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    cell.request = self.requests[indexPath.row];
    return cell;
}

@end
