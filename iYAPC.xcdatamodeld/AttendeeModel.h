//
//  AttendeeModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PersonModel.h"

@class SessionModel;

@interface AttendeeModel :  PersonModel  
{
}

@property (nonatomic, retain) NSSet* sessions;

@end


@interface AttendeeModel (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(SessionModel *)value;
- (void)removeSessionsObject:(SessionModel *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

