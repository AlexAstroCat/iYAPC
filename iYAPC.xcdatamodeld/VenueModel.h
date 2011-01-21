//
//  VenueModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "LocationModel.h"

@class EventModel;

@interface VenueModel :  LocationModel  
{
}

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSSet* events;

@end


@interface VenueModel (CoreDataGeneratedAccessors)
- (void)addEventsObject:(EventModel *)value;
- (void)removeEventsObject:(EventModel *)value;
- (void)addEvents:(NSSet *)value;
- (void)removeEvents:(NSSet *)value;

@end

