//
//  TrackModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EventModel;
@class SessionModel;

@interface TrackModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) EventModel * event;
@property (nonatomic, retain) NSSet* sessions;

@end


@interface TrackModel (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(SessionModel *)value;
- (void)removeSessionsObject:(SessionModel *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

