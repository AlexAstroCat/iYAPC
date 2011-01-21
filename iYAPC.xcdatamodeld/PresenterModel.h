//
//  PresenterModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AttendeeModel.h"

@class SessionModel;

@interface PresenterModel :  AttendeeModel  
{
}

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSSet* presentingSessions;

@end


@interface PresenterModel (CoreDataGeneratedAccessors)
- (void)addPresentingSessionsObject:(SessionModel *)value;
- (void)removePresentingSessionsObject:(SessionModel *)value;
- (void)addPresentingSessions:(NSSet *)value;
- (void)removePresentingSessions:(NSSet *)value;

@end

