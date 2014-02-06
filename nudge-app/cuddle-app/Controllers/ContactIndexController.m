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
        self.objectsPerPage = 25;
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
    [self watchNotifications];
    [self loadObjects];
    [self pushUser];
}

- (void)viewDidLoad{
    [super viewDidLoad];
  [SVProgressHUD showWithStatus:@"Logging in..."];
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
- (void)pushUser{
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(Colleague *)friend {
    
    ContactInfoCell *cell = (ContactInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
    cell.userName.text = friend.name;
    
    cell.userPicture.layer.cornerRadius = 5;
    cell.userPicture.clipsToBounds = YES;
  
    if (friend.photo){
        cell.userPicture.file = friend.photo;
        [cell.userPicture loadInBackground];
    } else if (!!friend.facebook) {
        NSString *facebookImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", friend.facebook];
        NSData *facebookImgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookImageURL]];
        cell.userPicture.image = [UIImage imageWithData: facebookImgData];
    } else {
        cell.userPicture.image = [UIImage imageNamed:@"contact_without_image.png"];
    }
  
    if (friend.methodOfLastContact) {
      cell.contactTypeImage.image = friend.lastContactImage;
      cell.userLastContact.text = [friend.lastContactDate timeAgo];
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
  
    self.lastAddedColleague = [[Colleague alloc] initWithABPerson:person];
  
    [self performSegueWithIdentifier:@"contactShowSegue" sender:self];
  
    [SVProgressHUD dismiss];
  
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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contactShowSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ContactShowViewController *destViewController = segue.destinationViewController;
        [self removeNotifications];
        if (indexPath){
          destViewController.contact = [self.objects objectAtIndex:indexPath.row];
        } else if (self.lastAddedColleague != nil){
          destViewController.contact = self.lastAddedColleague;
        }
    }
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
