//
//  PublicDataManager.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-16.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

#import "ManagedObjectXMLSync.h"

@interface PublicDataManager : NSObject {
    NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectModel *_managedObjectModel;

	ManagedObjectXMLSync *_currentObjectSync;
	BOOL _isReloading;
	NSURL *_dataUrl;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) ManagedObjectXMLSync *currentObjectSync;
@property (nonatomic, retain) NSURL *dataUrl;
@property (nonatomic) BOOL isReloading;

+ (PublicDataManager*)sharedPublicDataManager;
- (BOOL)reloadData;
- (void)cancel;

@end
