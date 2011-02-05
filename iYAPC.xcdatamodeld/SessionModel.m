// 
//  SessionModel.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "SessionModel.h"

#import "AttendeeModel.h"
#import "DayModel.h"
#import "PresenterModel.h"
#import "TrackModel.h"

@implementation SessionModel 

@dynamic url;
@dynamic talk_id;
@dynamic summary;
@dynamic subtitle;
@dynamic revision;
@dynamic title;
@dynamic room;
@dynamic startTimeSection;
@dynamic duration;
@dynamic startTime;
@dynamic attendees;
@dynamic presenters;
@dynamic track;
@dynamic eventDay;

- (NSString*)startTimeSection {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [dateFormatter stringFromDate:self.startTime];
}

@end
