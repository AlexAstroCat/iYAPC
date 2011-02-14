//
//  SessionDetailViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "SessionDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WebViewController.h"

typedef enum {
	SessionDetailViewControllerSectionDescription,
	SessionDetailViewControllerSectionPresenter,
	SessionDetailViewControllerSectionInfo,
	SessionDetailViewControllerSectionActions,
	CountSessionDetailViewControllerSections
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
	[_summaryHeader release];
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
	NSString *durationStr = [NSString stringWithFormat:NSLocalizedString(@"%@ minutes", nil), self.sessionObject.duration];

	self.navigationItem.title = self.sessionObject.title;
	_summaryHeader.titleLabel.text = self.sessionObject.title;
	_summaryHeader.subtitleLabel.text = self.sessionObject.subtitle;
	_summaryHeader.durationLabel.text = durationStr;
	_summaryHeader.dateLabel.text = startTimeStr;
	[_summaryHeader sizeToFit];
	
	[self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SessionDetailViewControllerSectionDescription: {
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = self.sessionObject.summary;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;

				case 1:
					cell.textLabel.text = NSLocalizedString(@"More information", nil);
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					
				default:
					break;
			}
			break;
		}
			
		case SessionDetailViewControllerSectionPresenter: {
			break;
		}

		case SessionDetailViewControllerSectionInfo: {
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
			[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = NSLocalizedString(@"Begins", nil);
					cell.detailTextLabel.text = [dateFormatter stringFromDate:self.sessionObject.startTime];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
					
				case 1:
					cell.textLabel.text = NSLocalizedString(@"Ends", nil);
					cell.detailTextLabel.text = [dateFormatter stringFromDate:self.sessionObject.endTime];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
					
				case 2:
					cell.textLabel.text = NSLocalizedString(@"Room", nil);
					cell.detailTextLabel.text = self.sessionObject.room;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
					
				default:
					break;
			}
			break;
		}

		case SessionDetailViewControllerSectionActions: {
			switch (indexPath.row) {
				case 0:
					
					break;
					
				default:
					break;
			}
			break;
		}
			
		default:
			break;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CountSessionDetailViewControllerSections;
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
		
		case SessionDetailViewControllerSectionPresenter:
			return [self.sessionObject.presenters count] > 0 ? 14.0 : 0.0;
			
		default:
			return 0.0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case SessionDetailViewControllerSectionPresenter: {
			switch ([self.sessionObject.presenters count]) {
				case 0:
					return nil;
				case 1:
					return NSLocalizedString(@"Presenter", nil);
				default:
					return NSLocalizedString(@"Presenters", nil);
			}
		}
			
		default:
			return nil;
	}
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
	int rowCount = 0;

	switch (section) {
		// Show the session description, if it has summary text
		case SessionDetailViewControllerSectionDescription: {
			if ([self.sessionObject.summary length] > 0)
				rowCount++;
			if ([self.sessionObject.url length] > 0)
				rowCount++;
			
			return rowCount;
		}

		// Show the list of presenters if there are any
		case SessionDetailViewControllerSectionPresenter:
			return [self.sessionObject.presenters count];
			
		case SessionDetailViewControllerSectionInfo: {
			rowCount = 2;
			if ([self.sessionObject.room length] > 0)
				rowCount++;
			
			return rowCount;
		}
			
		case SessionDetailViewControllerSectionActions:
		default:
			return rowCount;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
	UITableViewCellStyle cellStyle;
	switch (indexPath.section) {
		case SessionDetailViewControllerSectionPresenter:
			break;
			
		case SessionDetailViewControllerSectionInfo: {
			cellIdentifier = @"DetailSectionInfo";
			cellStyle = UITableViewCellStyleValue1;
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
		
		if (indexPath.section == SessionDetailViewControllerSectionDescription) {
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.font = [UIFont systemFontOfSize:14.0];
		}
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SessionDetailViewControllerSectionDescription && indexPath.row == 0)
		return nil;
	
	return indexPath;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SessionDetailViewControllerSectionDescription:
			if (indexPath.row == 1) {
				NSURL *url = [NSURL URLWithString:self.sessionObject.url];
				[self.navigationController pushViewController:[WebViewController webViewControllerAtURL:url] animated:YES];
			}
			break;
			
		default:
			break;
	}
}


@end

