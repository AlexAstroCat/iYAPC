//
//  InfoPanelViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-05.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoPanelViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	NSArray *_appsList;
}

- (IBAction)close:(id)sender;

@end
