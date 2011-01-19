//
//  SessionTabViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-12.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "SessionTabViewController.h"
#import "SessionDayViewController.h"

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
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	self.eventObject = nil;
	[self removeObserver:self forKeyPath:@"eventObject"];
	
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"eventObject"]) {
		if (_fetchedResultsController)
			self.fetchedResultsController = nil;
		
		[self fetchedResultsController];
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
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	NSArray *sortDescriptors = [NSArray arrayWithObjects:
								[NSSortDescriptor sortDescriptorWithKey:@"eventDate" ascending:YES],
								nil];
	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"event = %@", self.eventObject];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day"
											  inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setPredicate:searchPredicate];
    
	NSString *cacheName = [[self.eventObject objectID] description];
    NSFetchedResultsController *fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																					 managedObjectContext:self.managedObjectContext
																					   sectionNameKeyPath:nil
																								cacheName:cacheName];
    fetchedResults.delegate = self;
    self.fetchedResultsController = fetchedResults;    
    [fetchedResults release];
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
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
#pragma mark Private methods

- (void)updateTabs {
	NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]];
	for (DayModel *day in [self.fetchedResultsController fetchedObjects]) {
		SessionDayViewController *controller = [[[SessionDayViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		controller.managedObjectContext = self.managedObjectContext;
		controller.dayObject = day;
		[controllers addObject:controller];
	}
	
	[self setViewControllers:controllers animated:YES];
}

@end
