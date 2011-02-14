//
//  VenueMapAnnotation.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-13.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "VenueMapAnnotation.h"


@implementation VenueMapAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	_coordinate = newCoordinate;
}

@end
