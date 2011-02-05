//
//  TrackModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-01.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EventModel;
@class SessionModel;

@interface TrackModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * track_id;
@property (nonatomic, retain) EventModel * event;
@property (nonatomic, retain) NSSet* sessions;

@end


@interface TrackModel (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(SessionModel *)value;
- (void)removeSessionsObject:(SessionModel *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

