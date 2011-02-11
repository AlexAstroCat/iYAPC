//
//  SponsorModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-10.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EventModel;

@interface SponsorModel :  NSManagedObject  
{
}

@property (nonatomic, retain) EventModel * event;

@end



