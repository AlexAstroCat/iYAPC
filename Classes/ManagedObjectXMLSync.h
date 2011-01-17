//
//  ManagedObjectXMLSync.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-16.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ManagedObjectXMLSync;

@protocol ManagedObjectXMLSyncDelegate
@optional

- (void)managedObjectXMLSync:(ManagedObjectXMLSync*)xmlSync didStartXMLDocument:(NSXMLParser*)parser;
- (void)managedObjectXMLSync:(ManagedObjectXMLSync*)xmlSync didEndXMLDocument:(NSXMLParser*)parser;
- (void)managedObjectXMLSync:(ManagedObjectXMLSync*)xmlSync parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)error;
- (void)managedObjectXMLSync:(ManagedObjectXMLSync*)xmlSync parser:(NSXMLParser*)parser validationErrorOccurred:(NSError*)error;
- (void)managedObjectXMLSync:(ManagedObjectXMLSync*)xmlSync saveErrorOccurred:(NSError*)error;

@end

@interface ManagedObjectXMLSync : NSObject <NSXMLParserDelegate> {
    NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSDictionary *_elementNameMapping;
	NSMutableSet *_pendingIdMapping;
	
	NSXMLParser *_xmlParser;
	
	NSEntityDescription *_currentEntity;
	NSManagedObject *_currentModelObject;
	NSMutableString *_currentString;
	NSString *_currentModelObjectTagName;
	NSPropertyDescription *_currentProperty;

	id <ManagedObjectXMLSyncDelegate> delegate;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSDictionary *elementNameMapping;
@property (nonatomic, assign) id <ManagedObjectXMLSyncDelegate> delegate;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)objectContext withManagedObjectModel:(NSManagedObjectModel*)objectModel;
- (BOOL)syncContentsOfURL:(NSURL*)url;
- (BOOL)syncData:(NSData*)data;
- (void)cancel;

@end
