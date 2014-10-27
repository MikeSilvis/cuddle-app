//
//  ContactShowViewController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactShowViewController.h"
#import "FrequencyPickerNavigationControllerViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "NSDate+English.h"
#import "ContactHistory.h"
#import "UIImage+ContactMethod.h"

@implementation ContactShowViewController

@synthesize contact;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self disableButtonsWithoutInfo];
  [self loadStyles];
  self.screenName = @"Contact Show";
  self.seeMore.hidden = YES;
  self.contactPhoto.image = contact.avatarPhoto;
  self.navigationController.topViewController.title = contact.name;
  [[NSNotificationCenter defaultCenter] addObserver:self
   selector:@selector(handleOpenedFromPush:)
   name:@"openedFromNotification"
   object:nil];
  
  self.NudgeTooltips.hidden = YES;
  if (!self.contact.methodOfLastContact) {
    [self addGettingStarted];
  }
  
}
- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:YES];
  [self checkFrequency];
}
- (void)loadStyles{
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.layer.borderColor = [UIColor whiteColor].CGColor;
  self.tableView.layer.cornerRadius = 5;
  self.tableView.layer.borderWidth = 2.0;
  self.tableView.clipsToBounds = YES;
  self.contactPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
  self.contactPhoto.layer.cornerRadius = 45;
  self.contactPhoto.clipsToBounds = YES;
  self.contactPhoto.layer.borderWidth = 2.0;

  // Toolbar
  self.call.image = [UIImage imageFromMethodOfContact:@"call"];
  self.text.image = [UIImage imageFromMethodOfContact:@"sms"];
  self.email.image = [UIImage imageFromMethodOfContact:@"email"];
  self.plus.image = [UIImage imageFromMethodOfContact:@"contacted"];
}
- (void)checkFrequency{
  if (!contact.frequency){
    [self performSegueWithIdentifier:@"frequencyPicker" sender:self];
  } else {
    [self queryParseHistory];
    [contact updateContact];
  }
}
- (void)disableButtonsWithoutInfo{
  if (([[contact.numbers allKeys] count]) == 0){
    self.call.enabled = NO;
  }
  if ((contact.email == nil) || ([contact.email isEqual: @""])){
    self.email.enabled = NO;
  }
}

- (void)addGettingStarted{
  self.NudgeTooltips.hidden = NO;
  self.tableView.hidden = YES;
  self.seeMore.hidden = YES;
}

- (void)handleOpenedFromPush:(NSNotification *)notification{
  [self.navigationController popViewControllerAnimated:NO];
}

- (void)removeGettingStarted{
  self.tableView.hidden = NO;
  self.seeMore.hidden = NO;
  self.NudgeTooltips.hidden = YES;
}

- (IBAction)emailButton:(id)sender {
  if ([MFMailComposeViewController canSendMail])
  {
    MFMailComposeViewController* emailCntrl = [[MFMailComposeViewController alloc] init];
    emailCntrl.mailComposeDelegate = self;
    [emailCntrl setToRecipients:@[contact.email]];
    [self presentViewController:emailCntrl animated:YES completion:nil];
  }
}

- (IBAction)textButton:(id)sender {
  NSArray*labels = [contact.numbers allKeys];
  
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Number to Text"
   delegate:self
   cancelButtonTitle:nil
   destructiveButtonTitle:nil
   otherButtonTitles:nil];
  
  for (int i = 0; i<labels.count; i++) {
    [actionSheet addButtonWithTitle:labels[i]];
  }
  
  [actionSheet addButtonWithTitle:@"Cancel"];
  actionSheet.cancelButtonIndex = labels.count;
  
  [actionSheet showInView:self.view];
}

- (IBAction)callButton:(id)sender {
  NSArray*labels = [contact.numbers allKeys];
  
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Number to Call"
   delegate:self
   cancelButtonTitle:nil
   destructiveButtonTitle:nil
   otherButtonTitles:nil];
  
  for (int i = 0; i<labels.count; i++) {
    [actionSheet addButtonWithTitle:labels[i]];
  }
  
  [actionSheet addButtonWithTitle:@"Cancel"];
  actionSheet.cancelButtonIndex = labels.count;
  
  [actionSheet showInView:self.view];
}

- (IBAction)markButton:(id)sender {
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Method of Communication"
    delegate:self
    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Called", @"Texted", @"Emailed", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}

- (IBAction)editFrequency:(id)sender {
  [self performSegueWithIdentifier:@"frequencyPicker" sender:self];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if ([actionSheet.title isEqual: @"Method of Communication"]){
    switch (buttonIndex) {
      case 0:
      [self saveCommunication:@"call"];
      break;
      case 1:
      [self saveCommunication:@"sms"];
      break;
      case 2:
      [self saveCommunication:@"email"];
      break;
    }
  } else if ([actionSheet.title isEqualToString:@"Number to Call"]){
    if (actionSheet.cancelButtonIndex == buttonIndex) {
      true;
    } else {
      NSString *URLString = [@"tel://" stringByAppendingString:[contact.numbers allValues][buttonIndex]];
      NSURL *URL = [NSURL URLWithString:URLString];
      [[UIApplication sharedApplication] openURL:URL];
      [self saveCommunication:@"call"];
    }
  } else if ([actionSheet.title isEqualToString:@"Number to Text"]){
    if (actionSheet.cancelButtonIndex == buttonIndex){
      true;
    } else {
      MFMessageComposeViewController *smsCntrl = [[MFMessageComposeViewController alloc] init];
      if([MFMessageComposeViewController canSendText])
      {
        smsCntrl.recipients = @[[contact.numbers allValues][buttonIndex]];
        smsCntrl.messageComposeDelegate = self;
        [self presentViewController:smsCntrl animated:YES completion:nil];
      }
    }
  }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  if (result == MFMailComposeResultSent){
    [self saveCommunication:@"email"];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
  if (result == MessageComposeResultSent){
    [self saveCommunication:@"sms"];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveCommunication:(NSString *)methodOfContact{
  // Save the relationship
  ContactHistory *newNetwork = [[ContactHistory alloc] init];
  newNetwork.colleague = contact;
  newNetwork.method = methodOfContact;
  [newNetwork saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded){
      // Update the app to respect todays communication
      [self queryParseHistory];
    }
  }];
  
  // Save last contact
  contact.methodOfLastContact = methodOfContact;
  contact.lastContactDate = [NSDate date];
  contact[@"notifiedSincePush"] = @YES;
  [contact saveEventually];

  [SVProgressHUD showWithStatus:@"Great job at keeping in touch!" maskType:SVProgressHUDMaskTypeBlack];
  [SVProgressHUD dismiss];

  NSDictionary *dimensions = @{@"method":methodOfContact};
  [PFAnalytics trackEvent:@"Contacted" dimensions:dimensions];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"contactHistorySegue"]){
    ContactHistoryController *destViewController = segue.destinationViewController;
    destViewController.contact = self.contact;
  }
  if([segue.identifier isEqualToString:@"frequencyPicker"]){
    FrequencyPickerNavigationControllerViewController *destViewController = segue.destinationViewController;
    destViewController.contact = self.contact;
  }
}
- (void)queryParseHistory{
  if (self.contact.objectId) {
    PFQuery *query = [ContactHistory query];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"colleague" equalTo:self.contact];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
        if (objects.count == 0){
          self.tableView.hidden = YES;
          self.seeMore.hidden = YES;
          [self addGettingStarted];
        } else if (objects.count < 3) {
          [self removeGettingStarted];
          self.seeMore.hidden = YES;
          self.contactHistory = objects;
          [self.tableView reloadData];
        } else {
          self.seeMore.hidden = NO;
          self.contactHistory = objects;
          [self removeGettingStarted];
          [self.tableView reloadData];
        }
      }
    }];
  }
}
#pragma mark - UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.contactHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"contactShowCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  ContactHistory *history = (self.contactHistory)[indexPath.row];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }
  
  cell.textLabel.text = [NSDate makeEnglishDate:history.createdAt];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  cell.imageView.image = history.lastContactImage;

  return cell;
}

- (NSString *)formatDate:(NSDate *)date {
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
  NSString *suffix = suffixes[date_day];
  NSString *dateString = [prefixDateString stringByAppendingString:suffix];
  return dateString;
}
@end
