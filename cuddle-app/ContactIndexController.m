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
    
    if (photo){
        cell.userPicture.file = photo;
        [cell.userPicture loadInBackground];
    } else if ([object objectForKey:@"facebook"] != nil) {
        NSString *facebookImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [object objectForKey:@"facebook"]];
        NSData *facebookImgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookImageURL]];
        cell.userPicture.image = [UIImage imageWithData: facebookImgData];
    } else {
      cell.userPicture.image = [UIImage imageNamed:@"contact_without_image@2x.png"];
    }
    if ([[object objectForKey:@"methodOfLastContact"] isEqual:@"call"]) {
      cell.userLastContact.text = [@"Called on " stringByAppendingString:[self formatDate:object.createdAt]];;
    } else if ([[object objectForKey:@"methodOfLastContact"] isEqual:@"sms"]) {
      cell.userLastContact.text = [@"Texted on " stringByAppendingString:[self formatDate:object.createdAt]];;
    } else if ([[object objectForKey:@"methodOfLastContact"] isEqual:@"email"]) {
      cell.userLastContact.text = [@"Emailed on " stringByAppendingString:[self formatDate:object.createdAt]];;
    } else {
      cell.userLastContact.text = @"Never contacted from Cuddle";
    }
    return cell;
}

# pragma mark - Adding a Contact

- (IBAction)showPeoplePicker{
    [self selectPersonFromPicker];
}

- (void)selectPersonFromPicker{
//    self.view = addressesTable;
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
