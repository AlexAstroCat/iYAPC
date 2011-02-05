//
//  iYFetchedResultViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-02.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface iYFetchedResultTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>  {
	NSPredicate *_fetchPredicate;
	NSArray *_sortDescriptors;
	NSString *_sectionKeyPath;
	NSString *_entityName;
	NSString *_cacheName;
    NSFetchedResultsController *_fetchedResultsController;

@private
    NSManagedObjectContext *_managedObjectContext;
}

@property (nonatomic, retain) NSArray *sortDescriptors;
@property (nonatomic, retain) NSPredicate *fetchPredicate;
@property (nonatomic, retain) NSString *sectionKeyPath;
@property (nonatomic, retain) NSString *entityName;
@property (nonatomic, retain) NSString *cacheName;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
