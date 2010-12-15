//
//  EventModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DayModel;
@class LocationModel;

@interface EventModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * newAttribute;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * locationTitle;
@property (nonatomic, retain) LocationModel * location;
@property (nonatomic, retain) NSSet* days;

@end


@interface EventModel (CoreDataGeneratedAccessors)
- (void)addDaysObject:(DayModel *)value;
- (void)removeDaysObject:(DayModel *)value;
- (void)addDays:(NSSet *)value;
- (void)removeDays:(NSSet *)value;

@end

