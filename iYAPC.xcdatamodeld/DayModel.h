//
//  DayModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EventModel;
@class SessionModel;

@interface DayModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * eventDate;
@property (nonatomic, retain) EventModel * event;
@property (nonatomic, retain) NSSet* sessions;

@end


@interface DayModel (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(SessionModel *)value;
- (void)removeSessionsObject:(SessionModel *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

