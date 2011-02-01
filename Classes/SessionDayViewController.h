//
//  SessionDayViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayModel.h"

@interface SessionDayViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
	DayModel *_dayObject;

@private
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) DayModel *dayObject;

@end
