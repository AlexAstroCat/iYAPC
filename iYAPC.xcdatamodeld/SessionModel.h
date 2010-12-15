//
//  SessionModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DayModel;
@class PresenterModel;
@class TrackModel;

@interface SessionModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) DayModel * eventDay;
@property (nonatomic, retain) NSSet* presenters;
@property (nonatomic, retain) TrackModel * track;

@end


@interface SessionModel (CoreDataGeneratedAccessors)
- (void)addPresentersObject:(PresenterModel *)value;
- (void)removePresentersObject:(PresenterModel *)value;
- (void)addPresenters:(NSSet *)value;
- (void)removePresenters:(NSSet *)value;

@end

