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
#import "RequestDetailViewController.h"
#import "RequestFilterViewController.h"



@interface RequestsViewController () <NSFetchedResultsControllerDelegate, RequestFilterViewControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) RequestFilterViewController* filterViewController;
@end



@implementation RequestsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateFetchedResultsControllerForFilterType:FilterTypeDate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[ServiceManager sharedManager] loadRequestsWithHandler:^(id response, BOOL success, NSError *error) {
        
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
    }];
}

- (IBAction)filterButtonTapped:(id)sender
{
    [self showFilter];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RequestSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Request *request = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ((RequestDetailViewController*)segue.destinationViewController).request = request;
    }
}

- (void)updateTableViewHeader
{
    NSString* totalRequests = [NSString stringWithFormat:@"%d Requests", [self.fetchedResultsController.fetchedObjects count]];
    
    NSString* amountString = [[Request totalAmount] currencyString];
    NSString* totalPrice = [NSString stringWithFormat:@"%@ up for grabs", amountString];
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@\n%@", totalRequests, totalPrice];
}


#pragma mark - UITableView Delegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    cell.request = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - NSFetchedResultsController

- (void)updateFetchedResultsControllerForFilterType:(FilterType)filterType
{
    NSManagedObjectContext* context = [Request mainMOC];
    
    NSFetchRequest* request = [NSFetchRequest new];
    
    request.entity = [Request entityInContext:context];
    
    NSSortDescriptor* dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:NO];
    NSSortDescriptor* highestPriceSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO];
    NSSortDescriptor* lowestPriceSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES];

    switch (filterType) {
        case FilterTypeDate:
        default:
            request.sortDescriptors = @[dateSortDescriptor, highestPriceSortDescriptor];
            break;
            
        case FilterTypeHighestPrice:
            request.sortDescriptors = @[highestPriceSortDescriptor, dateSortDescriptor];
            break;
            
        case FilterTypeLowestPrice:
            request.sortDescriptors = @[lowestPriceSortDescriptor, dateSortDescriptor];
            break;
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];

    [self updateTableViewHeader];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            RequestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
            cell.request = [self.fetchedResultsController objectAtIndexPath:indexPath];
            break;
        }
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self updateTableViewHeader];
}


#pragma mark - Filter

- (RequestFilterViewController *)filterViewController
{
    if (!_filterViewController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _filterViewController = [storyboard instantiateViewControllerWithIdentifier:@"RequestFilterViewController"];
        _filterViewController.delegate = self;
    }
    return _filterViewController;
}

- (void)showFilter
{
    if (!self.filterViewController.view.superview)
    {
        self.filterViewController.view.frame = self.view.bounds;
        self.filterViewController.view.alpha = 0.0;
        [self.view addSubview:self.filterViewController.view];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.filterViewController.view.alpha = 1.0;
        }];
    }
}

- (void)hideFilter
{
    if (self.filterViewController.view.superview)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.filterViewController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.filterViewController.view removeFromSuperview];
        }];
    }
}

- (void)dismissFilterViewController:(RequestFilterViewController *)controller
{
    [self updateFetchedResultsControllerForFilterType:controller.filterType];
    [self hideFilter];
}


@end
