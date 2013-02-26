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
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    self.navigationItem.hidesBackButton = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactSaved:)
                                                 name:@"ContactSaved"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactFailed:)
                                                 name:@"ContactFailed"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectPersonFromPicker:)
                                                 name:@"PeoplePicker"
                                               object:nil];
}
- (void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error]; 
    if ([addressesTable numberOfRowsInSection:0] == 0){
        [self performSegueWithIdentifier:@"lonelySegue" sender:self];
    }

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

- (IBAction)showPeoplePicker{
    [self selectPersonFromPicker];
}

- (void)selectPersonFromPicker{
    self.view = addressesTable;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [SVProgressHUD showWithStatus:@"Saving Contact"];
    [[Colleague alloc] initWithABPerson:person];
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

- (void)contactSaved:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    [addressesTable reloadData];
    [self loadObjects];
}

- (void)contactFailed:(NSNotification *)notification{
    [SVProgressHUD showErrorWithStatus:@"Sorry there was an error. Try again"];
    NSLog(@"contact failed");
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contactShowSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ContactShowViewController *destViewController = segue.destinationViewController;
        destViewController.contact = [self.objects objectAtIndex:indexPath.row];
    }
}
@end
