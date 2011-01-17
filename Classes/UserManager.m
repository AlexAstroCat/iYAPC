//
//  UserManager.m
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-20.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "UserManager.h"


@implementation UserManager
SYNTHESIZE_SINGLETON_FOR_CLASS(UserManager);
@synthesize username = _username;
@synthesize password = _password;
@synthesize sessionId = _sessionId;

- (void)dealloc {
	self.username = nil;
	self.password = nil;
	self.sessionId = nil;
	
	[super dealloc];
}

@end
