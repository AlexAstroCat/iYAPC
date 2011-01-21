//
//  SessionDetailViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "SessionDetailViewController.h"

@interface SessionDetailViewController (Private)

- (void)updateSessionObject;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation SessionDetailViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize sessionObject = _sessionObject;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		[self addObserver:self
			   forKeyPath:@"sessionObject"
				  options:NSKeyValueObservingOptionNew
				  context:nil];
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self updateSessionObject];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"sessionObject"]) {
		[self updateSessionObject];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.managedObjectContext = nil;
	[self removeObserver:self forKeyPath:@"sessionObject"];
    [super dealloc];
}

#pragma mark -
#pragma mark Private methods

- (void)updateSessionObject {
	self.navigationItem.title = self.sessionObject.title;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.textLabel.text = session.title;
//	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startTimeStr, endTimeStr];
//	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SessionDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


@end

