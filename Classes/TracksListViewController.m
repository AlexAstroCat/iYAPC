//
//  TracksListViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-02.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "TracksListViewController.h"
#import "TrackModel.h"
#import "DNFetchedRequestManager.h"
#import "TrackSessionsViewController.h"

@implementation TracksListViewController

@synthesize eventObject = _eventObject;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.entityName = @"Track";
	self.sortDescriptors = [NSArray arrayWithObject:@"title"];
	self.fetchPredicate = [NSPredicate predicateWithFormat:@"event = %@", self.eventObject];
	self.cacheName = [NSString stringWithFormat:@"TrackListing%@", [self.eventObject objectID]];
	self.navigationItem.title = @"Tracks";
}

#pragma mark -
#pragma mark Private methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TrackModel *track = (TrackModel*)[self.fetchedResultsController objectAtIndexPath:indexPath];
	if (![track isMemberOfClass:[TrackModel class]])
		return;
	
    cell.textLabel.text = track.title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TrackModel *selectedObject = (TrackModel*)[self.fetchedResultsController objectAtIndexPath:indexPath];
	
	TrackSessionsViewController *controller = [[[TrackSessionsViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
	controller.managedObjectContext = self.managedObjectContext;
	controller.trackObject = selectedObject;
	
    [self.navigationController pushViewController:controller animated:YES];
}

@end
