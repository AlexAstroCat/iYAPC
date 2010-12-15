//
//  PresenterModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PersonModel.h"

@class SessionModel;

@interface PresenterModel :  PersonModel  
{
}

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSSet* sessions;

@end


@interface PresenterModel (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(SessionModel *)value;
- (void)removeSessionsObject:(SessionModel *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

