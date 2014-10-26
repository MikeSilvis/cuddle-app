//
//  LonelyController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/21/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Colleague.h"

@interface LonelyController : GAITrackedViewController <ABPeoplePickerNavigationControllerDelegate>

- (IBAction)showPeoplePicker:(id)sender;
@property (nonatomic, retain) Colleague *lastAddedColleague;

@end
