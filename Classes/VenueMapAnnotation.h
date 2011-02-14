//
//  VenueMapAnnotation.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-13.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VenueMapAnnotation : NSObject<MKAnnotation> {
	NSString *_title;
	NSString *_subtitle;
	CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
