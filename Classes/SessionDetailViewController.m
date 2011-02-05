//
//  SessionDetailViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "SessionDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
	SessionDetailViewControllerSectionDescription,
	SessionDetailViewControllerSectionPresenter,
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

	_summaryHeader = [[SessionSummaryHeaderView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 30)];
	
	[self updateSessionObject];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"sessionObject"]) {
		[self updateSessionObject];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
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
	if (!self.view)
		return;

	// Summary header
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *startTimeStr = [dateFormatter stringFromDate:self.sessionObject.startTime];
	NSString *durationStr = [NSString stringWithFormat:@"%@ minutes", self.sessionObject.duration];

	self.navigationItem.title = self.sessionObject.title;
	_summaryHeader.titleLabel.text = self.sessionObject.title;
	_summaryHeader.durationLabel.text = durationStr;
	_summaryHeader.dateLabel.text = startTimeStr;
	[_summaryHeader sizeToFit];
	
	[self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SessionDetailViewControllerSectionDescription: {
			cell.textLabel.text = self.sessionObject.summary;
			break;
		}
			
		case SessionDetailViewControllerSectionPresenter: {
			break;
		}
			
		case SessionDetailViewControllerSectionActions: {
			break;
		}

		default:
			break;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *header = nil;
	switch (section) {
		case SessionDetailViewControllerSectionDescription: {
			header = _summaryHeader;
			break;
		}
	}
	
	return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	switch (section) {
		case SessionDetailViewControllerSectionDescription:
			return _summaryHeader.bounds.size.height;
	}
	
	return 0.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case SessionDetailViewControllerSectionPresenter: {
			switch ([self.sessionObject.presenters count]) {
				case 0:
					return nil;
				case 1:
					return @"Presenter";
				default:
					return @"Presenters";
			}
		}
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SessionDetailViewControllerSectionDescription:
			return [self.sessionObject.summary sizeWithFont:[UIFont systemFontOfSize:14.0]
										  constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT)
											  lineBreakMode:UILineBreakModeWordWrap].height + 20;
			
		default:
			return 44.0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SessionDetailViewControllerSectionDescription:
			return 1;
			
		case SessionDetailViewControllerSectionPresenter:
			return [self.sessionObject.presenters count];
			
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
		case SessionDetailViewControllerSectionPresenter:
			break;
			
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
		
		if (indexPath.section == SessionDetailViewControllerSectionDescription) {
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.font = [UIFont systemFontOfSize:14.0];
		}
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SessionDetailViewControllerSectionDescription)
		return nil;
	
	return indexPath;
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

