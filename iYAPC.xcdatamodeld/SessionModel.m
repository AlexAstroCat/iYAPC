// 
//  SessionModel.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-17.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "SessionModel.h"

#import "AttendeeModel.h"
#import "DayModel.h"
#import "PresenterModel.h"
#import "TrackModel.h"

@implementation SessionModel 

@dynamic room;
@dynamic revision;
@dynamic subtitle;
@dynamic endTime;
@dynamic title;
@dynamic startTime;
@dynamic caption;
@dynamic eventDay;
@dynamic presenters;
@dynamic track;
@dynamic attendees;

- (NSString*)startTimeSection {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	NSString *dateStr = [dateFormatter stringFromDate:self.startTime];
	return dateStr;
}

@end
