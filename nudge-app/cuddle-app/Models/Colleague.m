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
@dynamic numbers;
@dynamic frequency;
@dynamic notifiedSincePush;
@dynamic lastContactDate;

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
      
      [self updatePhoneNumberInformation:abPerson];

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
- (void)updateContact {
  ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
  ABRecordRef abPerson = ABAddressBookGetPersonWithRecordID(addressBook, [self.recordId intValue]);
  
  NSDictionary *oldNumbers = self.numbers;

  [self updatePhoneNumberInformation:abPerson];

  if (![self.numbers isEqualToDictionary:oldNumbers]){
    [self saveEventually];
  }
}
- (void)updatePhoneNumberInformation:(ABAddressBookRef)abPerson {
  self.numbers = [[NSMutableDictionary alloc] initWithCapacity:20];
  NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() -"];
  ABMultiValueRef phones = ABRecordCopyValue(abPerson, kABPersonPhoneProperty);
  for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
    NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
    NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
    CFRelease(phoneNumberRef);
    CFRelease(locLabel);
    NSString *cleanedNumber = [[phoneNumber componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    [self.numbers setObject:cleanedNumber forKey:phoneLabel];
  }
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
