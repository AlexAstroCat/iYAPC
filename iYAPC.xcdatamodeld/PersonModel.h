//
//  PersonModel.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "LocationModel.h"


@interface PersonModel :  LocationModel  
{
}

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * nickname;

@end



