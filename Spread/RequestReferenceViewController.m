//
//  RequestReferenceViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/19/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import "RequestReferenceViewController.h"
#import "UIFont+Spread.h"
#import "CameraManager.h"
#import "User+Spread.h"
#import "Reference+Spread.h"
#import "RequestWebViewController.h"


@interface RequestReferenceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSArray *references;
@end


@implementation RequestReferenceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.references = self.request.sortedReferences;

    if ([self.request.requester.userID isEqual:[User currentUser].userID])
    {
        self.submitButton.hidden = YES;
    }
}

- (IBAction)submitButtonTapped:(id)sender
{
    [CameraManager sharedManager].request = self.request;
    [[CameraManager sharedManager] presentImagePickerInViewController:self];
}


#pragma mark - UITableView Delegate/DataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.references count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ReferenceCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Reference %d", indexPath.row];
    cell.textLabel.font = [UIFont appFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    RequestWebViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"RequestWebViewController"];
    Reference *reference = self.references[indexPath.row];
    controller.URLString = reference.referenceURL;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
