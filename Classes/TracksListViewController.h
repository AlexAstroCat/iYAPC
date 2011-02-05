//
//  TracksListViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-02.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iYFetchedResultTableViewController.h"
#import "EventModel.h"

@interface TracksListViewController : iYFetchedResultTableViewController {
	EventModel *_eventObject;
}

@property (nonatomic, assign) EventModel *eventObject;

@end
