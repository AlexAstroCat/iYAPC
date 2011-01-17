//
//  AttendeeModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-17.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PersonModel.h"

@class SessionModel;

@interface AttendeeModel :  PersonModel  
{
}

@property (nonatomic, retain) NSSet* attendingSessions;

@end


@interface AttendeeModel (CoreDataGeneratedAccessors)
- (void)addAttendingSessionsObject:(SessionModel *)value;
- (void)removeAttendingSessionsObject:(SessionModel *)value;
- (void)addAttendingSessions:(NSSet *)value;
- (void)removeAttendingSessions:(NSSet *)value;

@end

