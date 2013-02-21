//
//  ContactController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactIndexController.h"


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
    PFFile *photo = [object objectForKey:@"photo"];
    
    if (photo){
        cell.userPicture.file = photo;
        [cell.userPicture loadInBackground];
    } else{
      cell.userPicture.image = [UIImage imageNamed:@"contact_without_image@2x.png"];
    }
    
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
    
    [self addPerson:person];
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
- (void)addPerson:(ABRecordRef)person
{
    // All of this should be in Colleague.h
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    NSData  *imgABData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);

    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    }
    
    [SVProgressHUD showWithStatus:@"Saving Contact"];
    UIImage *image = [UIImage imageWithData:imgABData];
    // If there is not an image greater then 140 we dont want to upload it to parse
    if (image.size.width > 140){
        self.imageFile = [PFFile fileWithData:imgABData];
        [self.imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded){
                PFObject *newColleague = [[PFObject alloc] initWithClassName:@"Colleague"];
                [newColleague setObject:self.imageFile forKey:@"photo"]; // This is causing an error now
                [newColleague setObject:phone forKey:@"number"];
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
    } else {
        PFObject *newColleague = [[PFObject alloc] initWithClassName:@"Colleague"];
        [newColleague setObject:phone forKey:@"number"];
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
    
    CFRelease(phoneNumbers);
    
    [addressesTable reloadData];
}
- (void)onContactAdded:(NSNotification *)notification {
    [self loadObjects];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contactShowSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ContactShowViewController *destViewController = segue.destinationViewController;
        destViewController.contact = [self.objects objectAtIndex:indexPath.row];
    }
}
@end
