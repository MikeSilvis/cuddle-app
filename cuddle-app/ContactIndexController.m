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

@synthesize colleagues;
@synthesize addressesTable;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    colleagues =[[NSMutableArray alloc] init];
}

# pragma mark - Table List

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [colleagues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactInfoCell *cell = (ContactInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
    
    int index = [indexPath indexAtPosition:1];
    Colleague *colleague = [colleagues objectAtIndex:index];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", colleague.firstName, colleague.lastName];
    
    [[cell textLabel] setText:fullName];
    
    return cell;
}

# pragma mark - Adding a Contact

- (IBAction)showPeoplePicker
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
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
    
    Colleague *new_colleague = [[Colleague alloc] init];
    new_colleague.firstName = firstName;
    new_colleague.lastName = lastName;
    
    [colleagues addObject:new_colleague];
    [addressesTable reloadData];
    
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
