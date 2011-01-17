//
//  ManagedObjectXMLSync.m
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-16.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "ManagedObjectXMLSync.h"

#define ManagedObjectXMLSyncDebug 0

#pragma mark -
#pragma mark ManagedObjectXMLSyncCrossReference

@interface ManagedObjectXMLSyncCrossReference : NSObject
{
	NSManagedObject *_object;
	NSRelationshipDescription *_property;
	NSPredicate *_predicate;
}

- (id)initWithManagedObject:(NSManagedObject*)managedObject relationshipProperty:(NSRelationshipDescription*)property predicate:(NSPredicate*)searchPredicate;
- (BOOL)findReferencesInContext:(NSManagedObjectContext*)context;

@end

@implementation ManagedObjectXMLSyncCrossReference

#pragma mark Object lifecycle

- (id)initWithManagedObject:(NSManagedObject*)managedObject relationshipProperty:(NSRelationshipDescription*)property predicate:(NSPredicate*)searchPredicate {
	self = [super init];
	if (self) {
		_object = [managedObject retain];
		_property = [property retain];
		_predicate = [searchPredicate retain];
	}
	
	return self;
}

- (void)dealloc {
	[_object release];
	[_property release];
	[_predicate release];
	[super dealloc];
}

#pragma mark Cross-reference update methods

- (BOOL)findReferencesInContext:(NSManagedObjectContext*)context {
	// We can only run this if we are stored in a context
	if (![_object isInserted] || ![[_object managedObjectContext] isEqual:context])
		return NO;
	
	NSEntityDescription *targetEntity = [_property destinationEntity];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:targetEntity];
	
	NSError *error = nil;
	NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
	if (!results)
		return NO;

	if ([_property isToMany]) {
		[_object setValue:results forKey:[_property name]];
	} else {
		NSManagedObject *result = [results lastObject];
		[_object setValue:result forKey:[_property name]];
	}
	
	return YES;
}

@end

#pragma mark -
#pragma mark ManagedObjectXMLSync

@interface ManagedObjectXMLSync (Private)

- (void)startObject:(NSEntityDescription*)entity;
- (void)saveCrossReference:(NSDictionary*)attributeDict fromManagedObject:(NSManagedObject*)object throughProperty:(NSPropertyDescription*)property;
- (id)getValueForProperty:(NSPropertyDescription*)property fromString:(NSString*)valueString;
- (NSArray*)findManagedObjectsWithIndexedPropertiesMatching:(NSManagedObject*)object;
- (BOOL)mergeModelObject:(NSManagedObject*)object withExistingObject:(NSManagedObject*)existingObject;
- (void)findCrossReferences;

@end

@implementation ManagedObjectXMLSync
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize elementNameMapping = _elementNameMapping;
@synthesize delegate;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)objectContext withManagedObjectModel:(NSManagedObjectModel*)objectModel {
	if ((self = [self init])) {
		_pendingIdMapping = [[NSMutableSet set] retain];
		
		self.elementNameMapping = [NSDictionary dictionary];
		self.managedObjectModel = objectModel;
		self.managedObjectContext = objectContext;
		_xmlParser = nil;
	}
	
	return self;
}

- (void)dealloc {
	self.managedObjectModel = nil;
	self.managedObjectContext = nil;
	self.elementNameMapping = nil;
	
	[_pendingIdMapping release];
	[_currentModelObject release];
	[_currentModelObjectTagName release];
	[_currentEntity release];
	[_currentString release];
	[_currentProperty release];
	[_xmlParser release];
	
	[super dealloc];
}

#pragma mark Methods

- (BOOL)syncContentsOfURL:(NSURL*)url {
	if (_xmlParser)
		return NO;
	
	_xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	_xmlParser.delegate = self;
	return [_xmlParser parse];
}

- (BOOL)syncData:(NSData*)data {
	if (_xmlParser)
		return NO;
	
	_xmlParser = [[NSXMLParser alloc] initWithData:data];
	_xmlParser.delegate = self;
	return [_xmlParser parse];
}

- (void)cancel {
	[_xmlParser abortParsing];
}

#pragma mark Private methods

/**
 * Creates a new object for the XML block currently being processed.
 */
- (void)startObject:(NSEntityDescription*)entity {
	if (_currentEntity)
		[_currentEntity release];
	_currentEntity = [entity retain];
	
	NSString *className = [entity managedObjectClassName];
	Class entityClass = [[NSBundle mainBundle] classNamed:className];

	if (_currentModelObject != nil)
		[_currentModelObject release];
	_currentModelObject = [[entityClass alloc] initWithEntity:entity
							   insertIntoManagedObjectContext:nil];
}

/**
 * Saving cross-references is handled by looking at the key/value pair attributes bound to the element, and
 * uses the attribute name as the predicate property to search for, with the value being the expression used
 * to perform the search for that property.
 */
- (void)saveCrossReference:(NSDictionary*)attributeDict fromManagedObject:(NSManagedObject*)object throughProperty:(NSRelationshipDescription*)property {	
	NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:[attributeDict count]];

	// Iterate over attributes to build a list of search predicates
	NSEnumerator *enumerator = [attributeDict keyEnumerator];
	NSString *key;
	while ((key = [enumerator nextObject])) {
		NSString *value = [attributeDict objectForKey:key];
		NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value, nil];
		[predicates addObject:searchPredicate];
	}
	NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	
	// Create a cross-reference for this mapping
	ManagedObjectXMLSyncCrossReference *reference = [[[ManagedObjectXMLSyncCrossReference alloc] initWithManagedObject:object
																								  relationshipProperty:property
																											 predicate:compoundPredicate] autorelease];

	// Save the cross-reference for later
	[_pendingIdMapping addObject:reference];
}

/**
 * Helper function to extract a properly-typed value given the attribute type of the property.
 */
- (id)getValueForProperty:(NSPropertyDescription*)property fromString:(NSString*)valueString {
	id value = valueString;
	
	if ([property isKindOfClass:[NSAttributeDescription class]]) {
		NSAttributeDescription *attr = (NSAttributeDescription*)property;
		NSAttributeType attrType = [attr attributeType];
		
		if (attrType == NSInteger16AttributeType || attrType == NSInteger32AttributeType || attrType == NSInteger64AttributeType) {
			value = [NSNumber numberWithInteger:[valueString integerValue]];
		}
		
		else if (attrType == NSDecimalAttributeType || attrType == NSDoubleAttributeType || attrType == NSFloatAttributeType) {
			value = [NSNumber numberWithFloat:[valueString floatValue]];
		}
		
		else if (attrType == NSBooleanAttributeType) {
			NSString *lcVal = [valueString lowercaseString];
			if ([lcVal isEqualToString:@"yes"] || [lcVal isEqualToString:@"true"] || [lcVal isEqualToString:@"t"] || [lcVal integerValue] != 0) {
				value = [NSNumber numberWithBool:YES];
			} else {
				value = [NSNumber numberWithBool:NO];
			}
		}
		
		else if (attrType == NSDateAttributeType) {
			NSString *dateFormat = [[property userInfo] objectForKey:@"dateFormat"];
			if (!dateFormat || [dateFormat length] < 1)
				dateFormat = @"yyyy-MM-DDThh:mm:ssZ";
			
			NSString *localeStr = [[property userInfo] objectForKey:@"locale"];
			if (!localeStr || [localeStr length] < 1)
				localeStr = @"en_US";
			
			NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:localeStr] autorelease];
			NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
			[formatter setLocale:locale];
			[formatter setDateFormat:dateFormat];
			NSDate *date = [formatter dateFromString:valueString];
			
			value = date;
		}
		
		else if (attrType == NSBinaryDataAttributeType) {
			value = [valueString dataUsingEncoding:NSUTF8StringEncoding];
		}
	}
	
	return value;
}

/**
 * Given a reference managed object, this method finds all other objects of the same type that
 * have indexed properties matching the same values.
 */
- (NSArray*)findManagedObjectsWithIndexedPropertiesMatching:(NSManagedObject*)object {
	NSMutableArray *predicates = [NSMutableArray array];
	NSEntityDescription *entity = [object entity];
	NSString *revisionPropertyName = [[entity userInfo] objectForKey:@"revisionKey"];
	if (!revisionPropertyName)
		revisionPropertyName = @"revision";
	
	// Find the indexed properties and create a predicate to search for them
	for (NSAttributeDescription *property in [entity properties]) {
		if (![property isKindOfClass:[NSAttributeDescription class]] || ![property isIndexed])
			continue;
		if ([[property name] isEqualToString:revisionPropertyName])
			continue;
		
		NSString *propertyName = [property name];
		NSLog(@"Evaluating \"%@\" for comparison to \"%@\"", propertyName, [entity name]);
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", propertyName, [object valueForKey:propertyName]];
		[predicates addObject:predicate];
	}
	
	NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	
	// Create a fetch request to find the applicable objects
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:compoundPredicate];
	
	NSError *error = nil;
	NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (!results)
		return nil;

	// Return the managed objects, minus the reference object
	NSMutableArray *foundObjects = [NSMutableArray arrayWithArray:results];
	[foundObjects removeObject:object];
	return foundObjects;
}

/**
 Merges the new object with other objects that already exist.
 
 Since there is already another object with the same indexed properties, we need
 to determine how this should be merged; Either
   (a) for entities that have a "revisionKey" userInfo property, we compare
       the value in the property of that name to determine if the new object
       should overwrite the old one;
   (b) the entity shouldn't be merged with new results, causing the new value
       to be ignored / removed;
   (c) any new entities should automatically be added, regardless of whether
       or not they're unique.
 
 Returns true if the object was merged successfully, or false if the object
 should still be added to the model.
*/
- (BOOL)mergeModelObject:(NSManagedObject*)newObject withExistingObject:(NSManagedObject*)existingObject {
	NSEntityDescription *entity = [newObject entity];
	
	NSString *allowDuplicatesStr = [[entity userInfo] objectForKey:@"allowDuplicates"];
	BOOL allowDuplicates = (allowDuplicatesStr && [allowDuplicatesStr boolValue]);
	NSString *revisionPropertyName = [[entity userInfo] objectForKey:@"revisionKey"];
	if (!revisionPropertyName)
		revisionPropertyName = @"revision";
	NSAttributeDescription *revisionProperty = [[entity propertiesByName] objectForKey:revisionPropertyName];
	
	// If they set allowDuplicates to true, and they don't have a revision
	// property name, then the model object should be added anyway.
	if (allowDuplicates && !revisionProperty)
		return NO;
	
	// If they didn't set allowDuplicates to true, and we still don't have
	// a revision property, then this would be a duplicate and shouldn't be added.
	if (!allowDuplicates && !revisionProperty)
		return YES;
	
	// Figure out which one is the newest, and update the current object with that
	NSObject *oldRevision = [existingObject valueForKey:revisionPropertyName];
	NSObject *newRevision = [newObject valueForKey:revisionPropertyName];

#ifdef ManagedObjectXMLSyncDebug
	NSLog(@"Comparing old revision %@ to new revision %@", oldRevision, newRevision);
#endif
	
	SEL compare = @selector(compare:);
	if (![oldRevision respondsToSelector:compare] || ![newRevision respondsToSelector:compare]) {
#ifdef ManagedObjectXMLSyncDebug
		NSLog(@"Object of type %@ cannot be used to compare revisions", [oldRevision class]);
#endif
		return YES;
	}
	
	// See if the new object isn't newer
	NSComparisonResult compareResult = [oldRevision compare:newRevision];
	if (compareResult != NSOrderedAscending)
		return YES;
	
	// Merge the two objects together
	for (NSPropertyDescription *property in [entity properties]) {
		NSString *propertyName = [property name];

#ifdef ManagedObjectXMLSyncDebug
		NSLog(@"Property name: %@", propertyName);
#endif
		
		if ([propertyName isEqualToString:@"objectID"])
			continue;
		
		id existingValue = [existingObject valueForKey:propertyName];
		id newValue = [newObject valueForKey:propertyName];
		if (!newValue && !existingValue)
			continue;
		
		if (existingValue && ![existingValue isEqual:newValue])
			[existingObject setValue:newValue forKey:propertyName];
	}
	
	return YES;
}

- (void)findCrossReferences {
	NSMutableSet *completedReferences = [NSMutableSet set];
	
	for (ManagedObjectXMLSyncCrossReference *crossReference in _pendingIdMapping) {
		if ([crossReference findReferencesInContext:self.managedObjectContext]) {
			[completedReferences addObject:crossReference];
		}
	}
	
	for (ManagedObjectXMLSyncCrossReference *finishedReference in completedReferences) {
		[_pendingIdMapping removeObject:finishedReference];
	}
}

#pragma mark NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	if (self.delegate)
		[self.delegate managedObjectXMLSync:self didStartXMLDocument:parser];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[self findCrossReferences];
	[_pendingIdMapping removeAllObjects];
	
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	if (error != nil && self.delegate)
		[self.delegate managedObjectXMLSync:self saveErrorOccurred:error];

	if (self.delegate)
		[self.delegate managedObjectXMLSync:self didEndXMLDocument:parser];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	if (self.delegate)
		[self.delegate managedObjectXMLSync:self parser:parser parseErrorOccurred:parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
	if (self.delegate)
		[self.delegate managedObjectXMLSync:self parser:parser validationErrorOccurred:validationError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	NSString *entityName = [self.elementNameMapping objectForKey:elementName];
	if (!entityName)
		entityName = elementName;
	
	// Check if this tag represents a new object
	NSEntityDescription *entity = [[self.managedObjectModel entitiesByName] objectForKey:entityName];
	if (entity) {
		[self startObject:entity];
		if (_currentModelObjectTagName)
			[_currentModelObjectTagName release];
		_currentModelObjectTagName = [elementName copy];
	}
	
	// Check if this tag is a property
	else if (_currentModelObject) {
		// If this property is a relationship, add a cross reference lookup command object for later
		NSPropertyDescription *property = [[_currentEntity propertiesByName] objectForKey:entityName];
		if ([property isKindOfClass:[NSRelationshipDescription class]] && [attributeDict count] > 0) {
			[self saveCrossReference:attributeDict fromManagedObject:_currentModelObject throughProperty:property];
		}
		
		// Otherwise we should store the XML's content in this property
		else {
			if (_currentProperty)
				[_currentProperty release];
			if (_currentString)
				[_currentString release];
			
			_currentProperty = [property retain];			
			_currentString = [[NSMutableString string] retain];
		}
	}
	
	// Skip a bogus element
	else {
#ifdef ManagedObjectXMLSyncDebug
		NSLog(@"Ignoring element \"%@\" at line %d, column %d", elementName, [parser lineNumber], [parser columnNumber]);
#endif
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	// Set the current value to the appropriate property if this tag is for an object's property
	if (_currentProperty) {
		id value = [self getValueForProperty:_currentProperty fromString:_currentString];
		NSString *propertyName = [_currentProperty name];
		
#ifdef ManagedObjectXMLSyncDebug
		NSLog(@"Setting \"%@\" for property \"%@\"", value, propertyName);
#endif
		
		[_currentModelObject setValue:value forKey:propertyName];
		[_currentString release];
		[_currentProperty release];
		_currentString = nil;
		_currentProperty = nil;
	}
	
	// If this represents the end of an object, store it.
	else if (_currentModelObject && [elementName isEqualToString:_currentModelObjectTagName]) {
		
		// Find any objects that match the current indexed property values
		NSArray *matchingObjects = [self findManagedObjectsWithIndexedPropertiesMatching:_currentModelObject];
		if (matchingObjects && [matchingObjects count] > 0) {
			NSManagedObject *existingObject = [matchingObjects lastObject];
			
			// Merge the objects, or add the new one anyway if the entity tells us to
			if (![self mergeModelObject:_currentModelObject withExistingObject:existingObject]) {
				NSLog(@"Merged old object %@ with existing object %@", _currentModelObject, existingObject);
				[self.managedObjectContext insertObject:_currentModelObject];
			}
		} else {
			// Add this object to the object context
			[self.managedObjectContext insertObject:_currentModelObject];
		}
		
		// Clean up the model object for the next XML block
		[_currentModelObject release];
		_currentModelObject = nil;
		
		// Find any cross-references that may have been added in this block
		[self findCrossReferences];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (_currentString)
		[_currentString appendString:string];
}

@end
