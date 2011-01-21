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

typedef enum {
	MainMenuViewControllerViewTagNone,
	MainMenuViewControllerViewTagRoundedBox
} MainMenuViewControllerViewTag;

@implementation MainMenuViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize eventObject = _eventObject;
@synthesize headerImageView = _headerImageView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = self.eventObject.title;
	[self.headerImageView setImage:self.eventObject.headerImage];
	
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.managedObjectContext = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)peopleButtonTapped:(id)sender {
}

- (IBAction)myProfileButtonTapped:(id)sender {
}

- (IBAction)myScheduleButtonTapped:(id)sender {
}

- (IBAction)tracksButtonTapped:(id)sender {
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

- (IBAction)venueButtonTapped:(id)sender {
}

- (IBAction)sponsorsButtonTapped:(id)sender {
}

- (IBAction)infoButtonTapped:(id)sender {
}


@end
