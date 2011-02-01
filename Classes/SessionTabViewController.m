//
//  SessionTabViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-12.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "SessionTabViewController.h"
#import "SessionDayViewController.h"
#import "DNFetchedRequestManager.h"

@interface SessionTabViewController (Private)

- (void)updateTabs;

@end

@implementation SessionTabViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize eventObject = _eventObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.delegate = self;
		[self addObserver:self forKeyPath:@"eventObject" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self updateTabs];
}

- (void)viewDidUnload {
	self.fetchedResultsController = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.managedObjectContext = nil;
	[self removeObserver:self forKeyPath:@"eventObject"];
	
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"eventObject"]) {
		self.fetchedResultsController = nil;
		[self updateTabs];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"event = %@", self.eventObject];
	NSString *cacheName = [NSString stringWithFormat:@"TabListing%@", [self.eventObject objectID]];
	self.fetchedResultsController = [[DNFetchedRequestManager sharedInstance] resultsControllerInContext:self.managedObjectContext
																						   forEntityName:@"Day"
																						   withPredicate:searchPredicate
																					  withSectionKeyPath:nil
																						  usingCacheName:cacheName
																								sortedBy:@"eventDate"];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}    

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self updateTabs];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	self.navigationItem.title = viewController.navigationItem.title;
}

#pragma mark -
#pragma mark Private methods

- (void)updateTabs {
	if (!self.eventObject || !self.managedObjectContext)
		return;
	
	NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]];
	for (DayModel *day in [self.fetchedResultsController fetchedObjects]) {
		SessionDayViewController *controller = [[[SessionDayViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		controller.managedObjectContext = self.managedObjectContext;
		controller.dayObject = day;
		[controllers addObject:controller];
	}
	
	[self setViewControllers:controllers animated:YES];

	self.navigationItem.title = [[[controllers objectAtIndex:0] navigationItem] title];
}

@end
