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
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}
- (void)savePushChannel {
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  if (![currentInstallation.channels containsObject:[PFUser currentUser].objectId]){
    [currentInstallation addUniqueObject:[PFUser currentUser].objectId forKey:@"channels"];
    [currentInstallation saveInBackground];
  }
}
- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:@"Colleague"];
  [query whereKey:@"user" equalTo:[PFUser currentUser]];
  [query orderByAscending:@"updatedAt"];
  return query;
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadObjects];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
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
                                             selector:@selector(selectPersonFromPicker)
                                                 name:@"PeoplePicker"
                                               object:nil];
  self.navigationItem.titleView = [self titleView];
  [self savePushChannel];
}
- (void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
    if (([addressesTable numberOfRowsInSection:0] == 0) && (self.parseDidLoad == false)){
        [self performSegueWithIdentifier:@"lonelySegue" sender:self];
        [self setParseDidLoad:YES];
    }
}
- (UIView *)titleView {
  CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
  CGFloat width = 0.95 * self.view.frame.size.width;
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight)];
  
  UIImage *logo = [UIImage imageNamed:@"logo.png"];
  
  UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [logoButton setEnabled:NO];
  CGFloat logoY = floorf((navBarHeight - logo.size.height) / 2.0f) + 3;
  CGFloat centerPosition = floorf((width - logo.size.width) / 2.0f);
  
  [logoButton setFrame:CGRectMake(centerPosition, logoY, logo.size.width, logo.size.height)];
  [logoButton setImage:logo forState:UIControlStateDisabled];
  
  [containerView addSubview:logoButton];
  
  return containerView;
}
# pragma mark - Table List
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    ContactInfoCell *cell = (ContactInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
    cell.userName.text = [object objectForKey:@"name"];
    PFFile *photo = [object objectForKey:@"photo"];
    
    cell.userPicture.layer.cornerRadius = 5;
    cell.userPicture.clipsToBounds = YES;
    cell.userLastContact.text = [object.updatedAt timeAgo];
  
    if (photo){
        cell.userPicture.file = photo;
        [cell.userPicture loadInBackground];
    } else if ([object objectForKey:@"facebook"] != nil) {
        NSString *facebookImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [object objectForKey:@"facebook"]];
        NSData *facebookImgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookImageURL]];
        cell.userPicture.image = [UIImage imageWithData: facebookImgData];
    }

    if ([[object objectForKey:@"methodOfLastContact"] isEqual:@"call"]) {
//      cell.contactTypeImage.image = [UIimage ]
      cell.contactTypeImage.image = [UIImage imageNamed:@"phone-gray.png"];
//      cell.userLastContact.text = [@"Called " stringByAppendingString:[object.updatedAt timeAgo]];
    } else if ([[object objectForKey:@"methodOfLastContact"] isEqual:@"sms"]) {
            cell.contactTypeImage.image = [UIImage imageNamed:@"sms-gray.png"];
//      cell.userLastContact.text = [@"Texted " stringByAppendingString:[object.updatedAt timeAgo]];
    } else if ([[object objectForKey:@"methodOfLastContact"] isEqual:@"email"]) {
            cell.contactTypeImage.image = [UIImage imageNamed:@"email-gray.png"];
//      cell.userLastContact.text = [@"Emailed " stringByAppendingString:[object.updatedAt timeAgo]];
    } else if ([[object objectForKey:@"methodOfLastContact"] isEqual:@"contacted"]) {
            cell.contactTypeImage.image = [UIImage imageNamed:@"checkmark-gray.png"];
//      cell.userLastContact.text = [@"Contacted " stringByAppendingString:[object.updatedAt timeAgo]];
    } else {
      cell.contactTypeImage.layer.hidden = YES;
      cell.userLastContact.text = @"Never contacted from nudge";
    }
  

  
    return cell;
}

# pragma mark - Adding a Contact

- (IBAction)showPeoplePicker{
    [self selectPersonFromPicker];
}

- (void)selectPersonFromPicker{
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
    self.lastAddedColleague = [[notification userInfo] objectForKey:@"contact"];
    [self performSegueWithIdentifier:@"contactShowSegue" sender:self];
}

- (void)contactFailed:(NSNotification *)notification{
    [SVProgressHUD showErrorWithStatus:@"Sorry there was an error. Try again"];
    NSLog(@"contact failed");
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contactShowSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ContactShowViewController *destViewController = segue.destinationViewController;
        if (indexPath){
          destViewController.contact = [self.objects objectAtIndex:indexPath.row];
        } else if (self.lastAddedColleague != nil){
          destViewController.contact = self.lastAddedColleague;
        }
    }
}
- (NSString *)formatDate:(NSDate *)date{
  NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
  [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
  [prefixDateFormatter setDateFormat:@"MMMM d"];
  NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
  NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
  [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
  [monthDayFormatter setDateFormat:@"d"];
  int date_day = [[monthDayFormatter stringFromDate:date] intValue];
  NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
  NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
  NSString *suffix = [suffixes objectAtIndex:date_day];
  NSString *dateString = [prefixDateString stringByAppendingString:suffix];
  return dateString;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [SVProgressHUD showWithStatus:@"Removing Contact..."];
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [SVProgressHUD dismiss];
      [self loadObjects];
    }];
  }
}
@end
