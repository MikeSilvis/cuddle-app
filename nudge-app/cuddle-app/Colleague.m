//
//  Colleague.m
//  cuddle-app
//
//  Created by Paul Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "Colleague.h"

@implementation Colleague

- (id)initWithABPerson:(ABRecordRef)abPerson {
    self = [super init];
    if (self) {
        NSInteger recordID  =  ABRecordGetRecordID(abPerson);
        self.recordId = [NSNumber numberWithInt:recordID];
        NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(abPerson, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(abPerson, kABPersonLastNameProperty);
      
        ABMultiValueRef emails = ABRecordCopyValue(abPerson, kABPersonEmailProperty);
        self.email = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, 0));

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
            self.phoneNumber = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
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
  PFQuery *query = [PFQuery queryWithClassName:@"Colleague"];
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
    PFObject *newColleague = [[PFObject alloc] initWithClassName:@"Colleague"];
    [newColleague setObject:[PFUser currentUser] forKey:@"user"];
    if (self.photo){
        [newColleague setObject:self.photo forKey:@"photo"];
    }
    if (self.phoneNumber){
        [newColleague setObject:self.phoneNumber forKey:@"number"];
    }
    if (self.email){
          [newColleague setObject:self.email forKey:@"email"];
    }
    if (self.twitter){
      [newColleague setObject:self.twitter forKey:@"twitter"];
    }
    if (self.facebook){
      [newColleague setObject:self.facebook forKey:@"facebook"];
    }
    [newColleague setObject:self.recordId forKey:@"recordId"];
    [newColleague setObject:self.name forKey:@"name"];
    [newColleague saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            NSMutableDictionary *userData = [NSMutableDictionary dictionary];
            [userData setObject:newColleague forKey:@"contact"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactSaved" object:self userInfo:userData];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactFailed" object:self];
        }
        
    }];
}
@end
