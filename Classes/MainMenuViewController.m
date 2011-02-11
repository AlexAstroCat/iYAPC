//
//  MainMenuViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "MainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "SessionTabViewController.h"
#import "SessionDayViewController.h"
#import "TracksListViewController.h"
#import "InfoPanelViewController.h"

#import "DNFetchedRequestManager.h"

typedef enum {
	MainMenuViewControllerViewTagNone,
	MainMenuViewControllerViewTagRoundedBox
} MainMenuViewControllerViewTag;

@implementation MainMenuViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize eventObject = _eventObject;
@synthesize headerImageView = _headerImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = self.eventObject.title;
	[self.headerImageView setImage:self.eventObject.headerImage];
	
	// Update view layers to make it mo-bettah
	for (UIView *subview in self.view.subviews) {
		switch (subview.tag) {
			case MainMenuViewControllerViewTagRoundedBox:
				subview.layer.cornerRadius = 10.0;
				subview.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
				subview.layer.borderWidth = 1.0;
				break;
			default:
				break;
		}
	}
	
	// Conditionally show buttons on this view
	if ([self.eventObject.sponsors count] == 0) {
		[_sponsorsButton removeFromSuperview];
		[_sponsorsButton release];
		_sponsorsButton = nil;
	}
}

- (void)dealloc {
	self.managedObjectContext = nil;
	if (_sponsorsButton)
		[_sponsorsButton release];

    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)attendeesButtonTapped:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented"
													message:@"This feature isn't finished yet. Sorry!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)myProfileButtonTapped:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented"
													message:@"This feature isn't finished yet. Sorry!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)myScheduleButtonTapped:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented"
													message:@"This feature isn't finished yet. Sorry!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)sessionsButtonTapped:(id)sender {
	UIViewController *viewcontroller;
	
	// If we have more than one day, show the tab view controller
	if ([self.eventObject.days count] > 1) {
		SessionTabViewController *controller = [[[SessionTabViewController alloc] initWithNibName:nil bundle:nil] autorelease];
		controller.managedObjectContext = self.managedObjectContext;
		controller.eventObject = self.eventObject;
		viewcontroller = controller;
	}
	
	// If we only have one day to this event, simply show that day's event
	else {
		SessionDayViewController *controller = [[[SessionDayViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		controller.managedObjectContext = self.managedObjectContext;
		controller.dayObject = [self.eventObject.days anyObject];
		viewcontroller = controller;
	}
	
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)tracksButtonTapped:(id)sender {
	TracksListViewController *controller = [[[TracksListViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
	controller.managedObjectContext = self.managedObjectContext;
	controller.eventObject = self.eventObject;
	
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)venueButtonTapped:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented"
													message:@"This feature isn't finished yet. Sorry!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)sponsorsButtonTapped:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented"
													message:@"This feature isn't finished yet. Sorry!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)infoButtonTapped:(id)sender {
	InfoPanelViewController *controller = [[[InfoPanelViewController alloc] initWithNibName:@"InfoPanelViewController" bundle:nil] autorelease];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController presentModalViewController:controller animated:YES];
}


@end
