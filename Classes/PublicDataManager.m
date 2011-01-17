//
//  PublicDataManager.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-16.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "PublicDataManager.h"
#import "iYAPCAppDelegate.h"

@implementation PublicDataManager
SYNTHESIZE_SINGLETON_FOR_CLASS(PublicDataManager);
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize currentObjectSync = _currentObjectSync;
@synthesize dataUrl = _dataUrl;
@synthesize isReloading = _isReloading;

#pragma mark -
#pragma mark Object lifecycle

- (id)init {
	self = [super init];
	if (self) {
		iYAPCAppDelegate *delegate = (iYAPCAppDelegate*)[UIApplication sharedApplication].delegate;
		self.managedObjectContext = delegate.managedObjectContext;
		self.managedObjectModel = delegate.managedObjectModel;
		
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TestEvents" ofType:@"xml"];
		self.dataUrl = [NSURL fileURLWithPath:filePath];
	}

	return self;
}

- (void)dealloc {
	[_currentObjectSync release];
	
	self.managedObjectModel = nil;
	self.managedObjectContext = nil;
	self.dataUrl = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (BOOL)reloadData {
	if (self.currentObjectSync)
		[self cancel];
	
	_currentObjectSync = [[ManagedObjectXMLSync alloc] initWithManagedObjectContext:self.managedObjectContext
															 withManagedObjectModel:self.managedObjectModel];
	return [_currentObjectSync syncContentsOfURL:self.dataUrl];
}

- (void)cancel {
	if (!self.currentObjectSync)
		return;
	
	[self.currentObjectSync cancel];
	[_currentObjectSync release];
	_currentObjectSync = nil;
}

@end
