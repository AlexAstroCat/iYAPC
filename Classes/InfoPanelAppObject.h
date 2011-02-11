//
//  InfoPanelAppObject.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-10.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InfoPanelAppObject : NSObject {
	NSString *_title;
	NSString *_url;
	NSString *_iconUrl;
	UIImage *_iconImage;
	BOOL _imageLoading;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, retain) UIImage *iconImage;

- (id)initWithTitle:(NSString*)title appUrl:(NSString*)appUrl iconUrl:(NSString*)iconUrl;
- (void)loadImage;

@end
