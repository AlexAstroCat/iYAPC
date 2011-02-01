//
//  SessionDetailViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "SessionDetailViewController.h"

typedef enum {
	SessionDetailViewControllerSectionSummary,
	SessionDetailViewControllerSectionDescription,
	SessionDetailViewControllerSectionActions
} SessionDetailViewControllerSection;

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

- (void)dealloc {
	self.managedObjectContext = nil;
	[self removeObserver:self forKeyPath:@"sessionObject"];

    [super dealloc];
}

#pragma mark -
#pragma mark Private methods

- (void)updateSessionObject {
	self.navigationItem.title = self.sessionObject.title;
        [self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SessionDetailViewControllerSectionSummary: {
			break;
		}
			
		case SessionDetailViewControllerSectionDescription: {
			cell.textLabel.text = @"Foo";
			break;
		}
			
		case SessionDetailViewControllerSectionActions: {
			break;
		}

		default:
			break;
	}
//    cell.textLabel.text = session.title;
//	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startTimeStr, endTimeStr];
//	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SessionDetailViewControllerSectionSummary:
			return 0;
			
		case SessionDetailViewControllerSectionDescription:
			return 1;
			
		case SessionDetailViewControllerSectionActions:
			return 0;
			
		default:
			return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
	UITableViewCellStyle cellStyle;
	switch (indexPath.section) {
		case SessionDetailViewControllerSectionSummary: {
			if (indexPath.row == 0) {
				cellIdentifier = @"DetailSectionIcon";
				cellStyle = UITableViewCellStyleDefault;
			} else {
				cellIdentifier = @"DetailSectionInfo";
				cellStyle = UITableViewCellStyleValue1;
			}
			break;
		}
			
		case SessionDetailViewControllerSectionActions: {
			cellIdentifier = @"DetailSectionAction";
			cellStyle = UITableViewCellStyleSubtitle;
			break;
		}

		case SessionDetailViewControllerSectionDescription:
		default: {
			cellIdentifier = @"DetailSectionDescription";
			cellStyle = UITableViewCellStyleDefault;
			break;
		}
	}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
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

