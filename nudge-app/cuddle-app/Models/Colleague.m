//
//  Colleague.m
//  cuddle-app
//
//  Created by Paul Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "Colleague.h"
#import <Parse/PFObject+Subclass.h>

@interface Colleague ()
@end


@implementation Colleague

@dynamic user;
@dynamic name;
@dynamic email;
@dynamic photo;
@dynamic twitter;
@dynamic facebook;
@dynamic recordId;
@dynamic methodOfLastContact;
@dynamic numbers;
@dynamic number;
@dynamic frequency;
@dynamic notifiedSincePush;
@dynamic lastContactDate;

@synthesize avatarPhoto;


+ (NSString *)parseClassName {
  return @"Colleague";
}
- (id)initWithABPerson:(ABRecordRef)abPerson {
  self = [Colleague object];
  if (self) {
    self.user = [PFUser currentUser];
    NSInteger recordID  =  ABRecordGetRecordID(abPerson);
    self.recordId = @(recordID);
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(abPerson, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(abPerson, kABPersonLastNameProperty);
    
    if (lastName == NULL) {
      lastName = @"";
    }
    
    ABMultiValueRef emails = ABRecordCopyValue(abPerson, kABPersonEmailProperty);
    NSString* tmp_email = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, 0));

    self.email = (tmp_email == nil) ? @"" : tmp_email;
    self.notifiedSincePush = @YES;

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
  }
  return self;
}
- (UIImage *)avatarPhoto {
  if (!avatarPhoto) {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef abPerson = ABAddressBookGetPersonWithRecordID(addressBook, [self.recordId intValue]);
    NSData  *imgABData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(abPerson, kABPersonImageFormatOriginalSize);
    UIImage *image = [UIImage imageWithData:imgABData];
    
    if (!!image) {
      avatarPhoto = image;
    } else if (!!self.facebook) {
      NSString *facebookImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.facebook];
      NSData *facebookImgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookImageURL]];
      avatarPhoto = [UIImage imageWithData: facebookImgData];
    } else {
      avatarPhoto = [UIImage imageNamed:@"contact_without_image"];
    }
  }

  return avatarPhoto;
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
    (self.numbers)[phoneLabel] = cleanedNumber;
  }
}
- (UIImage *) lastContactImage{
  if ([self.methodOfLastContact isEqual:@"call"]) {
    return [UIImage imageNamed:@"phone-gray"];
  } else if ([self.methodOfLastContact isEqual:@"sms"]) {
    return [UIImage imageNamed:@"sms-gray.png"];
  } else if ([self.methodOfLastContact isEqual:@"email"]) {
    return [UIImage imageNamed:@"email-gray"];
  } else if ([self.methodOfLastContact isEqual:@"contacted"]) {
    return [UIImage imageNamed:@"checkmark-gray"];
  } else {
    return nil;
  }
}
@end
