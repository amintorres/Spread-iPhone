//
//  FeedViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "ListViewController.h"
#import "Photo.h"



@interface ListViewController ()
- (void)loadObjectsFromDataStore;
- (void)loadData;
@end



@implementation ListViewController

@synthesize tableView;
@synthesize photos;


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self loadData];    
}

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)loadObjectsFromDataStore
{
	NSFetchRequest* request = [Photo fetchRequest];
	NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	self.photos = [Photo objectsWithFetchRequest:request];
}

- (void)loadData
{
    // Load the object model via RestKit	
    //http://joinspread.com/photos.json?user_credentials=1fofoNKbvEz0RIDwE727
 
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/photos.json?user_credentials=1fofoNKbvEz0RIDwE727" delegate:self block:^(RKObjectLoader* loader) {

        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[Photo class]];
    }];
}


#pragma mark -
#pragma mark RKObjectLoader Delegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
	NSLog(@"Loaded objects: %@", objects);
	[self loadObjectsFromDataStore];
	[tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}


#pragma mark -
#pragma mark TableView

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* reuseIdentifier = @"PhotoCellIdentifier";
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	}

    Photo* photo = [photos objectAtIndex:indexPath.row];
	cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.photoDescription;
    
	return cell;
}



@end
