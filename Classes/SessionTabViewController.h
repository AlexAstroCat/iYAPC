//
//  SessionTabViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-12.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"

@interface SessionTabViewController : UITabBarController<UITabBarControllerDelegate, NSFetchedResultsControllerDelegate> {
	EventModel *_eventObject;

@private
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) EventModel *eventObject;

@end
