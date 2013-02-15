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

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.className = @"Colleague";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onContactAdded:)
                                                 name:@"ContactAdded"
                                               object:nil];
}

# pragma mark - Table List

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    ContactInfoCell *cell = (ContactInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
    cell.userName.text = [object objectForKey:@"name"];
    cell.userPicture.file = [object objectForKey:@"photo"];
    [cell.userPicture loadInBackground];
    
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
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    NSData  *imgABData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
    
    [SVProgressHUD showWithStatus:@"Saving Contact"];
    self.imageFile = [PFFile fileWithData:imgABData];
    [self.imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            PFObject *newColleague = [[PFObject alloc] initWithClassName:@"Colleague"];
            [newColleague setObject:self.imageFile forKey:@"photo"];
            [newColleague setObject:name forKey:@"name"];
            [newColleague saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded){
                    [SVProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactAdded" object:self];
                } else {
                    NSLog(@"Contact failed to upload");
                    [SVProgressHUD showErrorWithStatus:@"Sorry there was an error. Try again"];
                }
             
            }];
        }
    }];
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    CFRelease(phoneNumbers);
    
//    Colleague *newColleague = [[Colleague alloc] init];
//    newColleague.firstName = firstName;
//    newColleague.lastName = lastName;
//    newColleague.photo = [UIImage imageWithData:imgData];
//    newColleague.phoneNumber = (__bridge NSString *)(phoneNumbers);
    
//    [colleagues addObject:newColleague];
//    [newColleague setObject:phoneNumbers forKey:@"phoneNumbers"];
    
    [addressesTable reloadData];
}
- (void)onContactAdded:(NSNotification *)notification {
    [self loadObjects];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contactShowSegue"]){
        NSLog(@"%@", sender);
        NSLog(@"I need to pass information into contactShowSegue to determine the person i am on");
//        NSLog(@"%@", selectedRow);
    }
}
@end
