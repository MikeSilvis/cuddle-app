//
//  ContactController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactIndexController : UITableViewController <ABPeoplePickerNavigationControllerDelegate>
- (IBAction)addNewContact;
@end
