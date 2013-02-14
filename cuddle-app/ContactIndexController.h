//
//  ContactController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Colleague.h"
#import <Parse/Parse.h>

@interface ContactIndexController : PFQueryTableViewController <ABPeoplePickerNavigationControllerDelegate>

- (IBAction)showPeoplePicker;

@property (strong, nonatomic) IBOutlet UITableView *addressesTable;
@property (nonatomic, copy) NSMutableArray *colleagues;
@property PFFile *imageFile;

@end