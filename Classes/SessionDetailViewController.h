//
//  SessionDetailViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionModel.h"

@interface SessionDetailViewController : UITableViewController {
	SessionModel *_sessionObject;
	
@private
    NSManagedObjectContext *_managedObjectContext;	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SessionModel *sessionObject;


@end
