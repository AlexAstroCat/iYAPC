//
//  SessionModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-17.
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

@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) DayModel * eventDay;
@property (nonatomic, retain) NSSet* presenters;
@property (nonatomic, retain) TrackModel * track;
@property (nonatomic, retain) NSSet* attendees;

@end


@interface SessionModel (CoreDataGeneratedAccessors)
- (void)addPresentersObject:(PresenterModel *)value;
- (void)removePresentersObject:(PresenterModel *)value;
- (void)addPresenters:(NSSet *)value;
- (void)removePresenters:(NSSet *)value;

- (void)addAttendeesObject:(AttendeeModel *)value;
- (void)removeAttendeesObject:(AttendeeModel *)value;
- (void)addAttendees:(NSSet *)value;
- (void)removeAttendees:(NSSet *)value;

@end

