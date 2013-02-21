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

@interface Colleague : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSString *phoneNumber;
@property UIImage *photo;

- (NSString *) fullName;
- (id)initWithAbPerson;

@end
