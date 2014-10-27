//
//  ContactController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/QuartzCore.h> 
#import <AddressBookUI/AddressBookUI.h>
#import "Colleague.h"
#import "SVProgressHUD.h"
#import <Parse/Parse.h>
#import "ContactInfoCell.h"
#import "ContactShowViewController.h"
#import "NSDateTimeAgo.h"
#import "AppDelegate.h"
#import "GAITrackedViewController.h"

@interface ContactIndexController : UITableViewController <ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

- (IBAction)showPeoplePicker;

@property (strong, nonatomic) IBOutlet Colleague *lastAddedColleague;
@property BOOL firstLogin;

@property (nonatomic, retain) UIView *logoView;
@property (nonatomic, retain) UIView *lonelyView;
@property (nonatomic, retain) UIColor *separatorColor;

@property (nonatomic, retain) NSMutableArray *objects;

@end