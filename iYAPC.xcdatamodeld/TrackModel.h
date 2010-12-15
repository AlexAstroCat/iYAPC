//
//  TrackModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SessionModel;

@interface TrackModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSSet* sessions;

@end


@interface TrackModel (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(SessionModel *)value;
- (void)removeSessionsObject:(SessionModel *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

