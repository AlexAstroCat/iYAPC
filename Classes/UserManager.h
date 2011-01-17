//
//  UserManager.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-20.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface UserManager : NSObject {
	NSString *_username;
	NSString *_password;
	NSString *_sessionId;
}

@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *sessionId;

+ (UserManager*)sharedUserManager;

@end
