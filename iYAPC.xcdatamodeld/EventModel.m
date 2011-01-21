// 
//  EventModel.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-01-20.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "EventModel.h"

#import "DayModel.h"
#import "TrackModel.h"
#import "VenueModel.h"

@implementation EventModel 

@dynamic revision;
@dynamic subtitle;
@dynamic title;
@dynamic locationTitle;
@dynamic caption;
@dynamic tracks;
@dynamic venue;
@dynamic days;

@dynamic headerImageUrl;
@dynamic headerImage;

- (UIImage*)headerImage {
	if (!self.headerImageUrl || [self.headerImageUrl length] == 0)
		return nil;
	
	NSString *urlStr = self.headerImageUrl;

	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2) {
		urlStr = [urlStr stringByReplacingOccurrencesOfString:@".png"
												   withString:@"@2x.png"];
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [paths objectAtIndex:0];

	NSString *filename = [self.headerImageUrl lastPathComponent];
	NSString *filepath = [docPath stringByAppendingPathComponent:filename];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
		UIImage *image = [UIImage imageWithContentsOfFile:filepath];
		return image;
	}
	
	NSError *error = nil;
	NSURL *url = [NSURL URLWithString:urlStr];
	NSData *imageData = [NSData dataWithContentsOfURL:url
											  options:0
												error:&error];
	if (error) {
		NSLog(@"Error downloading %@: %@", self.headerImageUrl, error);
		return nil;
	}
	
	[imageData writeToFile:filepath atomically:YES];
	return [UIImage imageWithContentsOfFile:filepath];
}

@end
