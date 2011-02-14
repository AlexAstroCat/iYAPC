//
//  VenueDetailViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-13.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VenueModel.h"

@interface VenueDetailViewController : UITableViewController<UITableViewDelegate, MKMapViewDelegate> {
	VenueModel *_venueObject;
	MKMapView *_mapView;
	
@private
    NSManagedObjectContext *_managedObjectContext;	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) VenueModel *venueObject;

@end
