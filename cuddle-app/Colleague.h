//
//  Colleague.h
//  cuddle-app
//
//  Created by Paul Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@interface Colleague : PFObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) PFObject *photo;

- (id)initWithABPerson:(ABRecordRef)abPerson;
- (void)saveColleague;

@end
