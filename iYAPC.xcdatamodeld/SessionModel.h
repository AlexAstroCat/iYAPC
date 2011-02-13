//
//  SessionModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class AttendeeModel;
@class DayModel;
@class PresenterModel;
@class TrackModel;

@interface SessionModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * talk_id;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * startTimeSection;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSSet* attendees;
@property (nonatomic, retain) NSSet* presenters;
@property (nonatomic, retain) TrackModel * track;
@property (nonatomic, retain) DayModel * eventDay;

@end


@interface SessionModel (CoreDataGeneratedAccessors)
- (void)addAttendeesObject:(AttendeeModel *)value;
- (void)removeAttendeesObject:(AttendeeModel *)value;
- (void)addAttendees:(NSSet *)value;
- (void)removeAttendees:(NSSet *)value;

- (void)addPresentersObject:(PresenterModel *)value;
- (void)removePresentersObject:(PresenterModel *)value;
- (void)addPresenters:(NSSet *)value;
- (void)removePresenters:(NSSet *)value;

@end

