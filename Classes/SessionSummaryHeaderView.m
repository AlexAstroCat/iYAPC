//
//  SessionSummaryHeaderView.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-04.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "SessionSummaryHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define kHorizontalMargin 10.0
#define kVerticalMargin 10.0

@implementation SessionSummaryHeaderView

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize durationLabel = _durationLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		// Title header label
		CGRect titleRect = CGRectMake(kHorizontalMargin,
									  kVerticalMargin,
									  frame.size.width - kHorizontalMargin * 2,
									  44.0);
		_titleLabel = [[UILabel alloc] initWithFrame:titleRect];
		_titleLabel.opaque = NO;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
		_titleLabel.textAlignment = UITextAlignmentLeft;
		_titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		_titleLabel.numberOfLines = 3;
		_titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
										UIViewAutoresizingFlexibleHeight);
		[self addSubview:_titleLabel];
		
		// Date header label
		CGRect dateRect = CGRectMake(kHorizontalMargin,
									 kVerticalMargin + titleRect.size.height,
									 titleRect.size.width / 2,
									 22.0);
		_dateLabel = [[UILabel alloc] initWithFrame:dateRect];
		_dateLabel.opaque = NO;
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.font = [UIFont systemFontOfSize:13.0];
		_dateLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_dateLabel.textAlignment = UITextAlignmentLeft;
		_dateLabel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
									   UIViewAutoresizingFlexibleRightMargin);
		[self addSubview:_dateLabel];		

		// Duration header label
		CGRect locationRect = CGRectMake(dateRect.origin.x + dateRect.size.width,
										 dateRect.origin.y,
										 dateRect.size.width,
										 dateRect.size.height);
		_durationLabel = [[UILabel alloc] initWithFrame:locationRect];
		_durationLabel.opaque = NO;
		_durationLabel.backgroundColor = [UIColor clearColor];
		_durationLabel.font = [UIFont systemFontOfSize:13.0];
		_durationLabel.textAlignment = UITextAlignmentRight;
		_durationLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_durationLabel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
										   UIViewAutoresizingFlexibleLeftMargin);
		[self addSubview:_durationLabel];		
	}
    return self;
}

- (void)dealloc {
	[_titleLabel release];
	[_dateLabel release];
	[_durationLabel release];
	
    [super dealloc];
}

- (CGSize)sizeThatFits:(CGSize)size {
	[_titleLabel sizeToFit];
	_titleLabel.frame = CGRectMake(kHorizontalMargin,
								   kVerticalMargin,
								   size.width - kHorizontalMargin * 2,
								   _titleLabel.bounds.size.height);
	_dateLabel.center = CGPointMake((size.width + kHorizontalMargin * 2) * 0.25,
									_titleLabel.frame.origin.y + _titleLabel.frame.size.height + _dateLabel.frame.size.height / 2);
	_durationLabel.center = CGPointMake((size.width - kHorizontalMargin) * 0.75,
										_dateLabel.center.y);

	CGRect totalFrame = CGRectInset(CGRectUnion(CGRectUnion(_durationLabel.frame,
															_dateLabel.frame),
												_titleLabel.frame),
									-kHorizontalMargin,
									-kVerticalMargin);
	return totalFrame.size;
}

@end
