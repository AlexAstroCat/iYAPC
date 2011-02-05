//
//  SessionDayViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iYFetchedResultTableViewController.h"
#import "DayModel.h"

@interface SessionDayViewController : iYFetchedResultTableViewController {
	DayModel *_dayObject;
}

@property (nonatomic, assign) DayModel *dayObject;

- (id)initWithStyle:(UITableViewStyle)style forDay:(DayModel*)day;

@end
