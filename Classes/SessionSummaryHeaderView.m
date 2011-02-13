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
@synthesize subtitleLabel = _subtitleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize durationLabel = _durationLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		// Title header label
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.opaque = NO;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
		_titleLabel.textAlignment = UITextAlignmentLeft;
		_titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		_titleLabel.numberOfLines = 3;
		_titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
										UIViewAutoresizingFlexibleHeight);
		[self addSubview:_titleLabel];
		
		// Subtitle header label
		_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_subtitleLabel.opaque = NO;
		_subtitleLabel.backgroundColor = [UIColor clearColor];
		_subtitleLabel.font = [UIFont systemFontOfSize:17.0];
		_subtitleLabel.textAlignment = UITextAlignmentLeft;
		_subtitleLabel.lineBreakMode = UILineBreakModeWordWrap;
		_subtitleLabel.numberOfLines = 3;
		_subtitleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
										   UIViewAutoresizingFlexibleHeight);
		[self addSubview:_subtitleLabel];
		
		// Date header label
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_dateLabel.opaque = NO;
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.font = [UIFont systemFontOfSize:13.0];
		_dateLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_dateLabel.textAlignment = UITextAlignmentLeft;
		_dateLabel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
									   UIViewAutoresizingFlexibleRightMargin);
		[self addSubview:_dateLabel];		

		// Duration header label
		_durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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
	[_subtitleLabel release];
	[_dateLabel release];
	[_durationLabel release];
	
    [super dealloc];
}

- (CGSize)sizeThatFits:(CGSize)size {
	[_titleLabel sizeToFit];
	[_subtitleLabel sizeToFit];
	[_dateLabel sizeToFit];
	[_durationLabel sizeToFit];
	
	CGFloat originY = kVerticalMargin;
	CGFloat width = size.width - kHorizontalMargin * 2;
	
	_titleLabel.frame = CGRectMake(kHorizontalMargin,
								   originY,
								   width,
								   _titleLabel.bounds.size.height);
	originY += _titleLabel.frame.origin.y + _titleLabel.frame.size.height;

	_subtitleLabel.frame = CGRectMake(kHorizontalMargin,
									  originY,
									  width,
									  _subtitleLabel.bounds.size.height);
	originY += _subtitleLabel.frame.size.height;

	_dateLabel.frame = CGRectMake(kHorizontalMargin,
								  originY,
								  width,
								  _dateLabel.bounds.size.height);
	
	_durationLabel.frame = CGRectMake(width - _durationLabel.bounds.size.width - kHorizontalMargin,
									  originY,
									  _durationLabel.bounds.size.width,
									  _durationLabel.bounds.size.height);
	originY += _durationLabel.frame.size.height;

	CGRect totalFrame = CGRectInset(CGRectUnion(CGRectUnion(_durationLabel.frame, _dateLabel.frame),
												CGRectUnion(_titleLabel.frame, _subtitleLabel.frame)),
									-kHorizontalMargin,
									-kVerticalMargin);
	return totalFrame.size;
}

@end
