//
//  ContactController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactIndexController.h"
#import "ContactInfoCell.h"

@interface ContactIndexController ()

@end

@implementation ContactIndexController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

# pragma mark - Table List

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactInfoCell *cell = (ContactInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
    
    return cell;
}

# pragma mark - Adding a Contact

- (IBAction)addNewContact {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
- (void)displayPerson:(ABRecordRef)person
{
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    NSLog(@"%@", name);
    
//
//    NSData  *imgData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
//    
//    self.userPhoto.image = [UIImage imageWithData:imgData];
//    self.firstName.text = name;
//    
//    NSString* phone = nil;
//    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
//                                                     kABPersonPhoneProperty);
//    if (ABMultiValueGetCount(phoneNumbers) > 0) {
//        phone = (__bridge_transfer NSString*)
//        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
//    } else {
//        phone = @"[None]";
//    }
//    self.phoneNumber.text = phone;
//    CFRelease(phoneNumbers);
}

@end
