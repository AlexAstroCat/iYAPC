//
//  SessionDetailViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-18.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionModel.h"
#import "SessionSummaryHeaderView.h"

@interface SessionDetailViewController : UITableViewController<UITableViewDelegate> {
	SessionModel *_sessionObject;
	
@private
	SessionSummaryHeaderView *_summaryHeader;
	UILabel *_descriptionLabel;
	
    NSManagedObjectContext *_managedObjectContext;	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) SessionModel *sessionObject;


@end
