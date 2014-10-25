//
//  ContactShowViewController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactShowViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

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
  CGFloat fontSize = 24;
  CGSize imageSize = CGSizeMake(24, 24);
  FAKFontAwesome *callIcon = [FAKFontAwesome phoneIconWithSize:fontSize];
  self.call.image = [callIcon imageWithSize:imageSize];
  
  FAKFontAwesome *textIcon = [FAKFontAwesome commentIconWithSize:fontSize];
  self.text.image = [textIcon imageWithSize:imageSize];

  FAKFontAwesome *emailIcon = [FAKFontAwesome envelopeIconWithSize:fontSize];
  self.email.image = [emailIcon imageWithSize:imageSize];

  FAKFontAwesome *plusIcon = [FAKFontAwesome thumbsUpIconWithSize:fontSize];
  self.plus.image = [plusIcon imageWithSize:imageSize];
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
- (void)addShadowToActions:(UIButton *)button{
  if (button.enabled){
    button.layer.shadowColor = [UIColor colorWithRed:74/255.0f green:149/255.0f blue:203/255.0f alpha:1.0f].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 0);
    button.layer.shadowRadius = 5.0;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = @0.0f;
    anim.toValue = @1.0f;
    anim.duration = 3.0;
    [button.layer addAnimation:anim forKey:@"shadowOpacity"];
    button.layer.shadowOpacity = 1.0;
  }
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
  PFObject *newNetwork = [[PFObject alloc] initWithClassName:@"ContactHistory"];
  newNetwork[@"colleague"] = contact;
  newNetwork[@"method"] = methodOfContact;
  [newNetwork saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded){
      // Update the app to respect todays communication
      [self queryParseHistory];
    }
  }];
  
    // Save last contact
  contact[@"methodOfLastContact"] = methodOfContact;
  contact[@"lastContactDate"] = [NSDate date];
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
    FrequencyPickerController *destViewController = segue.destinationViewController;
    destViewController.contact = self.contact;
  }
}
- (void)queryParseHistory{
  if (self.contact.objectId) {
    PFQuery *query = [PFQuery queryWithClassName:@"ContactHistory"];
    [query whereKey:@"colleague" equalTo:self.contact];
    [query orderByDescending:@"createdAt"];
    query.limit = 3;
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
  PFObject *history = (self.contactHistory)[indexPath.row];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }
  cell.textLabel.text = [self formatDate:history.createdAt];
  cell.textLabel.backgroundColor = [UIColor clearColor];

  FAKFontAwesome *icon;
  CGFloat fontSize = 24;

  if ([history[@"method"] isEqual:@"call"]) {
    icon = [FAKFontAwesome phoneIconWithSize:fontSize];
  } else if ([history[@"method"] isEqual:@"sms"]) {
    icon = [FAKFontAwesome commentIconWithSize:fontSize];
  } else if ([history[@"method"] isEqual:@"email"]) {
    icon = [FAKFontAwesome envelopeIconWithSize:fontSize];
  } else if ([history[@"method"] isEqual:@"contacted"]) {
    icon = [FAKFontAwesome thumbsUpIconWithSize:fontSize];
  }

  if (icon) {
    cell.imageView.image = [icon imageWithSize:CGSizeMake(24, 24)];
  }
  
  return cell;
}
- (NSString *)formatDate:(NSDate *)date
{
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
