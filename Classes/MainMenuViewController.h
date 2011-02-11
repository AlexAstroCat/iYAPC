//
//  MainMenuViewController.h
//  iYAPC
//
//  Created by Michael Nachbaur on 10-12-11.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"

@interface MainMenuViewController : UIViewController {
	EventModel *_eventObject;
	UIImageView *_headerImageView;
	IBOutlet UIButton *_sponsorsButton;

@private
    NSManagedObjectContext *_managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) EventModel *eventObject;
@property (nonatomic, retain) IBOutlet UIImageView *headerImageView;

- (IBAction)myProfileButtonTapped:(id)sender;
- (IBAction)myScheduleButtonTapped:(id)sender;

- (IBAction)sessionsButtonTapped:(id)sender;
- (IBAction)tracksButtonTapped:(id)sender;
- (IBAction)venueButtonTapped:(id)sender;
- (IBAction)attendeesButtonTapped:(id)sender;

- (IBAction)sponsorsButtonTapped:(id)sender;
- (IBAction)infoButtonTapped:(id)sender;

@end
