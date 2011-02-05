//
//  SessionSummaryHeaderView.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-04.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionSummaryHeaderView : UIView {
	UILabel *_titleLabel;
	UILabel *_dateLabel;
	UILabel *_durationLabel;
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *dateLabel;
@property (nonatomic, readonly) UILabel *durationLabel;

@end
