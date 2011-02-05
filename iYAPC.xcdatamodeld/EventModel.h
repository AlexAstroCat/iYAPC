//
//  EventModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DayModel;
@class TrackModel;
@class VenueModel;

@interface EventModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * locationTitle;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSSet* tracks;
@property (nonatomic, retain) VenueModel * venue;
@property (nonatomic, retain) NSSet* days;

@property (nonatomic, retain) NSString * headerImageUrl;
@property (nonatomic, retain) UIImage * headerImage;

@end


@interface EventModel (CoreDataGeneratedAccessors)
- (void)addTracksObject:(TrackModel *)value;
- (void)removeTracksObject:(TrackModel *)value;
- (void)addTracks:(NSSet *)value;
- (void)removeTracks:(NSSet *)value;

- (void)addDaysObject:(DayModel *)value;
- (void)removeDaysObject:(DayModel *)value;
- (void)addDays:(NSSet *)value;
- (void)removeDays:(NSSet *)value;

@end

