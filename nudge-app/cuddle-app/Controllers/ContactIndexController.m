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
    self.pullToRefreshEnabled = NO;
    self.paginationEnabled = YES;
    self.objectsPerPage = 100;
  }
  return self;
}
- (void)savePushChannel {
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  NSString *userChannel = [NSString stringWithFormat: @"user_%@", [PFUser currentUser].objectId];
  if (![currentInstallation.channels containsObject:userChannel]){
    [currentInstallation addUniqueObject:userChannel forKey:@"channels"];
    [currentInstallation saveInBackground];
  }
}
- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:@"Colleague"];
  [query whereKey:@"user" equalTo:[PFUser currentUser]];
  [query includeKey:@"ContactHistory"];
  [query orderByAscending:@"lastContactDate,updatedAt"];
  return query;
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidDisappear:YES];
  [self watchNotifications];
  [self loadObjects];
  [self pushUser];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];
  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.titleView = [self titleView];
  [self savePushChannel];
}
- (void)watchNotifications{
  [[NSNotificationCenter defaultCenter] addObserver:self
   selector:@selector(selectPersonFromPicker)
   name:@"PeoplePicker"
   object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
   selector:@selector(handleOpenedFromPush:)
   name:UIApplicationWillEnterForegroundNotification
   object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
   selector:@selector(handleOpenedFromPush:)
   name:@"openedFromNotification"
   object:nil];
}
- (void)removeNotifications{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"openedFromNotification" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PeoplePicker" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

}
- (void)objectsDidLoad:(NSError *)error{
  [super objectsDidLoad:error];
  if (self.parseDidLoad == false) {
    if ([addressesTable numberOfRowsInSection:0] == 0){
      [self performSegueWithIdentifier:@"lonelySegue" sender:self];
    }
    [self setParseDidLoad:YES];
  }

}
- (AppDelegate *)appDelegate{
  return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)handleOpenedFromPush:(NSNotification *)notification{
  [self pushUser];
}

- (void)pushUser {
  for (Colleague *object in self.objects) {
    if ([object.objectId isEqualToString:self.appDelegate.colleagueId]){
      self.lastAddedColleague = object;
      self.appDelegate.colleagueId = nil;
      [self performSegueWithIdentifier:@"contactShowSegue" sender:self];
    }
  }
}
- (UIView *)titleView {
  CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
  CGFloat width = 0.95 * self.view.frame.size.width;
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight)];
  
  UIImage *logo = [UIImage imageNamed:@"logo"];
  
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(Colleague *)friend {
  
  ContactInfoCell *cell = (ContactInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
  cell.userName.text = friend.name;
  
  cell.userPicture.layer.cornerRadius = 20;
  cell.userPicture.clipsToBounds = YES;

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
    UIImage *avatarPhoto = friend.avatarPhotoImage;
    
    dispatch_async(dispatch_get_main_queue(), ^() {
      cell.userPicture.image = avatarPhoto;
    });
  });

  cell.contactTypeImage.image = friend.lastContactImage;
  
  if (friend.methodOfLastContact) {
    cell.userLastContact.text = [friend.lastContactDate timeAgo];
  } else {
    cell.userLastContact.text = @"Never contacted from nudge";
  }
  
  return cell;
}
- (IBAction)showPeoplePicker{
  [self selectPersonFromPicker];
}

- (void)selectPersonFromPicker{
  CFErrorRef error;
  ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
  ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
  });
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
  [SVProgressHUD showWithStatus:@"Saving Contact" maskType:SVProgressHUDMaskTypeBlack];

  NSNumber *recordID  =  [NSNumber numberWithInt:ABRecordGetRecordID(person)];
  self.lastAddedColleague = nil;
  
  for (Colleague *object in self.objects) {
    if ([object.recordId isEqualToNumber:recordID]) {
      self.lastAddedColleague = object;
    }
  }
  
  if (self.lastAddedColleague == nil) {
    self.lastAddedColleague = [[Colleague alloc] initWithABPerson:person];
  }

  [SVProgressHUD dismiss];
  
  NSDictionary *dimensions = @{@"contactAdded":@"true"};
  [PFAnalytics trackEvent:@"contactAdded" dimensions:dimensions];

  [self dismissViewControllerAnimated:YES completion:nil];

  [self performSegueWithIdentifier:@"contactShowSegue" sender:self];

}

- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
  return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"contactShowSegue"]){
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ContactShowViewController *destViewController = segue.destinationViewController;
    [self removeNotifications];
    if (indexPath){
      destViewController.contact = (self.objects)[indexPath.row];
    } else if (self.lastAddedColleague != nil){
      destViewController.contact = self.lastAddedColleague;
    }
  }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [SVProgressHUD showWithStatus:@"Removing Contact..." maskType:SVProgressHUDMaskTypeBlack];
    PFObject *object = (self.objects)[indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [SVProgressHUD dismiss];
      [self loadObjects];
    }];
  }
}
@end
