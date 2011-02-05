//
//  TrackSessionsViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-02.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iYFetchedResultTableViewController.h"
#import "TrackModel.h"

@interface TrackSessionsViewController : iYFetchedResultTableViewController {
	TrackModel *_trackObject;
}

@property (nonatomic, assign) TrackModel *trackObject;

@end
