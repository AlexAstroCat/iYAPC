//
//  iYFetchedResultViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-02.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "iYFetchedResultTableViewController.h"
#import "DNFetchedRequestManager.h"

@implementation iYFetchedResultTableViewController

@synthesize sortDescriptors = _sortDescriptors;
@synthesize fetchPredicate = _fetchPredicate;
@synthesize sectionKeyPath = _sectionKeyPath;
@synthesize entityName = _entityName;
@synthesize cacheName = _cacheName;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		NSArray *keyPaths = [NSArray arrayWithObjects:
							 @"fetchPredicate", @"sortDescriptors", @"sectionKeyPath",
							 @"entityName", @"cacheName", @"managedObjectContext", nil];
		for (NSString *keyPath in keyPaths) {
			[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
		}
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"fetchPredicate"] ||
		[keyPath isEqualToString:@"sortDescriptors"] ||
		[keyPath isEqualToString:@"sectionKeyPath"] ||
		[keyPath isEqualToString:@"entityName"] ||
		[keyPath isEqualToString:@"cacheName"] ||
		[keyPath isEqualToString:@"managedObjectContext"]) {
		self.fetchedResultsController = nil;
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	[super viewDidUnload];
	self.fetchedResultsController = nil;
}

- (void)dealloc {
	self.sortDescriptors = nil;
	self.fetchPredicate = nil;
	self.sectionKeyPath = nil;
	self.entityName = nil;
	self.cacheName = nil;
	self.fetchedResultsController = nil;
	self.managedObjectContext = nil;
	
	NSArray *keyPaths = [NSArray arrayWithObjects:
						 @"fetchPredicate", @"sortDescriptors", @"sectionKeyPath",
						 @"entityName", @"cacheName", @"managedObjectContext", nil];
	for (NSString *keyPath in keyPaths) {
		[self removeObserver:self forKeyPath:keyPath];
	}
	
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use
			 this function in a shipping application, although it may be useful during development. If
			 it is not possible to recover from the error, display an alert panel that instructs the
			 user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cacheName];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cacheName] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    	
	DNFetchedRequestManager *requestManager = [DNFetchedRequestManager sharedInstance];
	self.fetchedResultsController = [requestManager resultsControllerInContext:self.managedObjectContext
																 forEntityName:self.entityName
																 withPredicate:self.fetchPredicate
															withSectionKeyPath:self.sectionKeyPath
																usingCacheName:self.cacheName
																	  sortedBy:self.sortDescriptors];
    self.fetchedResultsController.delegate = self;
	
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}    


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
