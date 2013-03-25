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

@interface Colleague : PFObject<PFSubclassing>

@property (nonatomic, retain) NSNumber *recordId;
@property (nonatomic, retain) NSNumber *notifiedSincePush;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *facebook;
@property (nonatomic, retain) NSString *twitter;
@property (nonatomic, retain) PFObject *photo;
@property (nonatomic, retain) PFUser *user;

+ (NSString *)parseClassName;
- (id)initWithABPerson:(ABRecordRef)abPerson;
- (void)saveColleague;

@end
