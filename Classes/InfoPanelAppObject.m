//
//  InfoPanelAppObject.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-10.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "InfoPanelAppObject.h"

@implementation InfoPanelAppObject
@synthesize title = _title;
@synthesize url = _url;
@synthesize iconUrl = _iconUrl;
@synthesize iconImage = _iconImage;

- (id)initWithTitle:(NSString*)title appUrl:(NSString*)appUrl iconUrl:(NSString*)iconUrl {
	self = [super init];
	if (self) {
		self.title = title;
		self.url = appUrl;
		self.iconUrl = iconUrl;
	}
	return self;
}

- (void)dealloc {
	self.title = nil;
	self.url = nil;
	self.iconUrl = nil;
	self.iconImage = nil;
	
	[super dealloc];
}

- (void)loadImage {
	if (_imageLoading)
		return;
	
	_imageLoading = YES;
	
	NSString *documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	NSString *iconDir = [documentDir stringByAppendingPathComponent:@"appIcons"];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if (![fm fileExistsAtPath:iconDir]) {
		[fm createDirectoryAtPath:iconDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	NSString *filename = [self.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *imagePath = [documentDir stringByAppendingPathComponent:filename];
	
	if ([fm fileExistsAtPath:imagePath]) {
		self.iconImage = [UIImage imageWithContentsOfFile:imagePath];
		return;
	}
	
	NSURL *url = [NSURL URLWithString:self.iconUrl];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	[imageData writeToFile:imagePath atomically:YES];
	
	self.iconImage = [UIImage imageWithContentsOfFile:imagePath];
}

@end
