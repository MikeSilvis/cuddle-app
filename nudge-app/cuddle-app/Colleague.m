//
//  Colleague.m
//  cuddle-app
//
//  Created by Paul Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "Colleague.h"
#import <Parse/PFObject+Subclass.h>

@implementation Colleague

@dynamic  user;
@dynamic name;
@dynamic email;
@dynamic photo;
@dynamic twitter;
@dynamic facebook;
@dynamic recordId;
@dynamic methodOfLastContact;
@dynamic number;
@dynamic frequency;
@dynamic notifiedSincePush;

+ (NSString *)parseClassName {
  return @"Colleague";
}
- (id)initWithABPerson:(ABRecordRef)abPerson {
    self = [Colleague object];
    if (self) {
        self.user = [PFUser currentUser];
        NSInteger recordID  =  ABRecordGetRecordID(abPerson);
        self.recordId = [NSNumber numberWithInt:recordID];
        NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(abPerson, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(abPerson, kABPersonLastNameProperty);
      
        if (lastName == NULL) {
          lastName = @"";
        }
      
        ABMultiValueRef emails = ABRecordCopyValue(abPerson, kABPersonEmailProperty);
        NSString* tmp_email = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, 0));

        self.email = (tmp_email == nil) ? @"" : tmp_email;

        ABMultiValueRef socialMulti = ABRecordCopyValue(abPerson, kABPersonSocialProfileProperty);
        for (CFIndex i = 0; i < ABMultiValueGetCount(socialMulti); i++) {
            NSDictionary* social = (__bridge NSDictionary*)ABMultiValueCopyValueAtIndex(socialMulti, i);
            if ([social[@"service"] isEqualToString:(__bridge NSString*)kABPersonSocialProfileServiceFacebook]) {
                self.facebook = (NSString*)social[@"username"];
            } else if ([social[@"service"] isEqualToString:(__bridge NSString*)kABPersonSocialProfileServiceTwitter]) {
              self.twitter = (NSString*)social[@"username"];
            }
        }

        self.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(abPerson, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
            self.number = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        }
        NSData  *imgABData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(abPerson, kABPersonImageFormatOriginalSize);
        UIImage *image = [UIImage imageWithData:imgABData];
        if (image.size.width > 1){
            self.photo = [PFFile fileWithData:imgABData];
            [self.photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded){
                    [self verifyNoOtherColleague];
                }
            }];
        } else {
            [self verifyNoOtherColleague];
        }
    }
    return self;
}
- (void)verifyNoOtherColleague{
  PFQuery *query = [Colleague query];
  [query whereKey:@"user" equalTo:[PFUser currentUser]];
  [query whereKey:@"recordId" equalTo:self.recordId];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (objects.count > 0){
      NSMutableDictionary *userData = [NSMutableDictionary dictionary];
      [userData setObject:objects[0] forKey:@"contact"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactSaved" object:self userInfo:userData];
    } else {
      [self saveColleague];
    }
  }];
}
- (void)saveColleague{
    self.notifiedSincePush = [NSNumber numberWithBool:YES];
    [self saveEventually];
}
- (UIImage *) lastContactImage{
  if ([self.methodOfLastContact isEqual:@"call"]) {
    return [UIImage imageNamed:@"phone-gray.png"];
  } else if ([self.methodOfLastContact isEqual:@"sms"]) {
    return [UIImage imageNamed:@"sms-gray.png"];
  } else if ([self.methodOfLastContact isEqual:@"email"]) {
    return [UIImage imageNamed:@"envelope-gray.png"];
  } else if ([self.methodOfLastContact isEqual:@"contacted"]) {
    return [UIImage imageNamed:@"checkmark-gray.png"];
  } else {
    return nil;
  }
}
@end
