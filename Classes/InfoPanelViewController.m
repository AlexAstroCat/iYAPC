//
//  InfoPanelViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-05.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "InfoPanelViewController.h"
#import "InfoPanelAppObject.h"

typedef enum {
	InfoPanelViewControllerSectionOverview,
	InfoPanelViewControllerSectionOtherApps,
	CountInfoPanelViewControllerSection
} InfoPanelViewControllerSection;

@interface InfoPanelViewController (Private)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation InfoPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		NSMutableArray *apps = [NSMutableArray array];
		InfoPanelAppObject *app;
		
		// aCookie
		app = [[[InfoPanelAppObject alloc] initWithTitle:@"aCookie Fortunes"
												  appUrl:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=309103871&mt=8" 
												 iconUrl:@"http://decafninja.com/apps/acookie/icon.png"] autorelease];
		[apps addObject:app];
		
		// myDrumPad
		app = [[[InfoPanelAppObject alloc] initWithTitle:@"myDrumPad"
												  appUrl:@"http://itunes.apple.com/us/app/mydrum-pad/id364787310?mt=8&uo=6" 
												 iconUrl:@"http://decafninja.com/apps/mydrumpad/icon.png"] autorelease];
		[apps addObject:app];
		
		// Boomle
		app = [[[InfoPanelAppObject alloc] initWithTitle:@"Boomle"
												  appUrl:@"http://itunes.apple.com/ca/app/boomle/id363484574?mt=8" 
												 iconUrl:@"http://decafninja.com/apps/boomle/icon.png"] autorelease];
		[apps addObject:app];
				
		_appsList = [[NSArray arrayWithArray:apps] retain];
	}
	return self;
}

- (void)dealloc {
	[_appsList release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return CountInfoPanelViewControllerSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case InfoPanelViewControllerSectionOverview:
			return 2;
			
		case InfoPanelViewControllerSectionOtherApps:
			return [_appsList count];

		default:
			return 0;
	}
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case InfoPanelViewControllerSectionOverview:
			return NSLocalizedString(@"What is iYAPC?", nil);
			
		case InfoPanelViewControllerSectionOtherApps:
			return NSLocalizedString(@"Apps by Decaf Ninja Software", nil);
			
		default:
			return nil;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
	UITableViewCellStyle cellStyle;
	switch (indexPath.section) {
		case InfoPanelViewControllerSectionOverview: {
			cellIdentifier = @"InfoOverviewSection";
			cellStyle = UITableViewCellStyleSubtitle;
			break;
		}
			
		default: {
			cellIdentifier = @"InfoAppsSection";
			cellStyle = UITableViewCellStyleDefault;
			break;
		}
	}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		switch (indexPath.section) {
			case InfoPanelViewControllerSectionOverview:
				switch (indexPath.row) {
					case 0:
						cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
						cell.textLabel.numberOfLines = 0;
						cell.textLabel.font = [UIFont systemFontOfSize:14.0];
						break;

					default:
						break;
				}
				break;

			default:
				break;
		}
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case InfoPanelViewControllerSectionOverview: {
			if (indexPath.row == 1) {
				NSURL *url = [NSURL URLWithString:@"http://github.com/NachoMan/iYAPC"];
				[[UIApplication sharedApplication] openURL:url];
				return nil;
			}
		}
			
		case InfoPanelViewControllerSectionOtherApps: {
			InfoPanelAppObject *app = [_appsList objectAtIndex:indexPath.row];
			NSURL *url = [NSURL URLWithString:app.url];
			[[UIApplication sharedApplication] openURL:url];
			return nil;
		}

		default:
			break;
	}

	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case InfoPanelViewControllerSectionOverview:
			break;
		
		default:
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	switch (indexPath.section) {
		case InfoPanelViewControllerSectionOverview: {
			switch (indexPath.row) {
				case 0:
					return [cell.textLabel.text sizeWithFont:cell.textLabel.font
										   constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT)
											   lineBreakMode:cell.textLabel.lineBreakMode].height + 30;

				default:
					return 44.0;
			}
		}

		default:
			return 44.0;
	}
}

#pragma mark -
#pragma mark Private methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case InfoPanelViewControllerSectionOverview: {
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = NSLocalizedString(@"iYAPC is a conference assistance tool to help the Perl Community and its attendees manage their schedules, discover conferences, and interact with other developers at Perl-related conferences and workshops.  It was written by Decaf Ninja Software and released to the community as Open Source Software.", nil);
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;

				case 1: {
					cell.textLabel.text = NSLocalizedString(@"iYAPC on Github", nil);
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
					
				default:
					break;
			}

			break;
		}

		case InfoPanelViewControllerSectionOtherApps: {
			InfoPanelAppObject *app = [_appsList objectAtIndex:indexPath.row];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.text = app.title;
			cell.imageView.image = app.iconImage;
			
			break;
		}
		
		default:
			break;
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction)close:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}


@end
