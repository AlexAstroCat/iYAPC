//
//  DNFetchedRequestManager.h
//  DNAdditions
//
//  Created by Michael Nachbaur on 11-01-22.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DNFetchedRequestManager : NSObject {

}

+ (DNFetchedRequestManager*)sharedInstance;

- (NSFetchRequest*)fetchRequestInContext:(NSManagedObjectContext*)context
						   forEntityName:(NSString*)entityName
						   withPredicate:(NSPredicate*)predicate
					  withSectionKeyPath:(NSString*)sectionName
						  usingCacheName:(NSString*)cacheName
								sortedBy:(id)sortDescriptors;
- (NSFetchedResultsController*)resultsControllerInContext:(NSManagedObjectContext*)context
											forEntityName:(NSString*)entityName
											withPredicate:(NSPredicate*)predicate
									   withSectionKeyPath:(NSString*)sectionName
										   usingCacheName:(NSString*)cacheName
												 sortedBy:(id)sortDescriptors;
	
- (NSArray*)resultsInContext:(NSManagedObjectContext*)context
			   forEntityName:(NSString*)entityName
			   withPredicate:(NSPredicate*)predicate
			  usingCacheName:(NSString*)cacheName;
- (NSInteger)resultCountInContext:(NSManagedObjectContext*)context
					forEntityName:(NSString*)entityName
					withPredicate:(NSPredicate*)predicate
				   usingCacheName:(NSString*)cacheName;
	
@end
