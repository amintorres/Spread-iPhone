//
//  AboutViewController.m
//  Spread
//
//  Created by Joseph Lin on 12/31/11.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "AboutViewController.h"
#import "MasterViewController.h"
#import "ServiceManager.h"


typedef enum{
    TableViewSectionMain = 0,
    TableViewSectionLogout,
    TableViewSectionCount
}TableViewSection;

typedef enum{
    TableViewMainSectionRowAbout = 0,
    TableViewMainSectionRowTeam,
    TableViewMainSectionRowTerms,
    TableViewMainSectionRowFeedback,
    TableViewMainSectionRowCount
}TableViewMainSectionRow;

typedef enum{
    TableViewLogoutSectionRowLogout = 0,
    TableViewLogoutSectionRowCount
}TableViewLogoutSectionRow;



@implementation AboutViewController

@synthesize tableView;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}


#pragma mark -
#pragma mark IBAction

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)logoutButtonTapped:(id)sender
{
    [ServiceManager logout];

    [self dismissModalViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:SpreadShouldLogoutNotification object:self];
}


#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TableViewSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( section == TableViewSectionMain )
    {
        return @"More";        
    }
    else
    {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if ( section == TableViewSectionMain )
    {
        return TableViewMainSectionRowCount;        
    }
    else
    {
        return TableViewLogoutSectionRowCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* reuseIdentifier = @"AboutTableViewCell";
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if ( indexPath.section == TableViewSectionMain )
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = UITextAlignmentLeft;

        switch (indexPath.row)
        {
            case TableViewMainSectionRowAbout:
                cell.textLabel.text = @"About";
                break;
                
            case TableViewMainSectionRowTeam:
                cell.textLabel.text = @"Team";
                break;
                
            case TableViewMainSectionRowTerms:
                cell.textLabel.text = @"Terms";
                break;
                
            case TableViewMainSectionRowFeedback:
            default:
                cell.textLabel.text = @"Feedback/Contact us";
                break;
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;

        switch (indexPath.row)
        {
            case TableViewLogoutSectionRowLogout:
            default:
                cell.textLabel.text = @"Logout";
                break;
        }
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.section == TableViewSectionMain )
    {
        switch (indexPath.row)
        {
            case TableViewMainSectionRowAbout:
                break;
                
            case TableViewMainSectionRowTeam:
                break;
                
            case TableViewMainSectionRowTerms:
                break;
                
            case TableViewMainSectionRowFeedback:
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case TableViewLogoutSectionRowLogout:
            default:
                [self logoutButtonTapped:nil];
                break;
        }
    }
}



@end
