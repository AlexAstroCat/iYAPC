//
//  LocationModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-17.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface LocationModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end



