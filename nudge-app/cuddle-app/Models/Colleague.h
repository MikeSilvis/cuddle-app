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
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSMutableDictionary *numbers;
@property (nonatomic, retain) NSString *facebook;
@property (nonatomic, retain) NSString *twitter;
@property (nonatomic, retain) NSString *methodOfLastContact;
@property (nonatomic, retain) NSDate *lastContactDate;
@property (nonatomic, retain) NSString *frequency;
@property (nonatomic, retain) PFFile *photo;
@property (nonatomic, retain) PFUser *user;
@property (nonatomic, retain) UIImage *avatarPhoto;

+ (NSString *)parseClassName;
- (UIImage *)lastContactImage;
- (id)initWithABPerson:(ABRecordRef)abPerson;
- (void)updateContact;
- (UIImage *)avatarPhotoImage;

@end
