//
//  ContactShowViewController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactShowViewController.h"

@implementation ContactShowViewController

@synthesize contact, started;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
  
    [self loadContactPhoto];
    [self disableButtonsWithoutInfo];
    [self loadStyles];
    [self loadContactHistory];
    self.contactName.text = [contact objectForKey:@"name"];

}
- (void)loadStyles{
  self.contactBackground.layer.shadowColor = [UIColor blackColor].CGColor;
  self.contactBackground.layer.shadowOffset = CGSizeMake(0, 1);
  self.contactBackground.layer.shadowOpacity = 1;
  self.contactBackground.layer.shadowRadius = 5.0;
  self.contactBackground.clipsToBounds = NO;
  self.contactHistoryView.layer.borderColor = [UIColor whiteColor].CGColor;
  self.contactHistoryView.layer.cornerRadius = 5;
  self.contactHistoryView.layer.borderWidth = 2.0;
  self.contactHistoryView.clipsToBounds = YES;
  self.contactPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
  self.contactPhoto.layer.cornerRadius = 5;
  self.contactPhoto.clipsToBounds = YES;
  self.contactPhoto.layer.borderWidth = 2.0;
}
- (void)loadContactPhoto{
  if ([contact objectForKey:@"photo"] != nil){
    self.contactPhoto.file = [contact objectForKey:@"photo"];
  } else if ([contact objectForKey:@"facebook"] != nil) {
    NSString *facebookImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [contact objectForKey:@"facebook"]];
    NSData *facebookImgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookImageURL]];
    self.contactPhoto.image = [UIImage imageWithData: facebookImgData];
  }
}
- (void)disableButtonsWithoutInfo{
  if (([contact objectForKey:@"number"] == nil) || ([[contact objectForKey:@"number"] isEqual: @""])){
    self.call.enabled = NO;
    self.text.enabled = NO;
  }
  if (([contact objectForKey:@"email"] == nil) || ([[contact objectForKey:@"email"] isEqual: @""])){
    self.email.enabled = NO;
  }
}
- (void)loadContactHistory{
  if (([contact objectForKey:@"methodOfLastContact"] == nil) || ([[contact objectForKey:@"methodOfLastContact"] isEqual: @""])){
    self.lastContactedTime.text = @" ";
    self.lastContactedText.hidden = YES;
    [self addGettingStarted];
  } else {
    self.lastContactedTime.text = [self formatDate:contact.updatedAt];
  }

//  if ([[contact objectForKey:@"methodOfLastContact"] isEqual:@"call"]) {
//    self.lastContactedTime.text = [@"Called on " stringByAppendingString:[self formatDate:contact.updatedAt]];
//  } else if ([[contact objectForKey:@"methodOfLastContact"] isEqual:@"sms"]) {
//    self.lastContactedTime.text = [@"Texted on " stringByAppendingString:[self formatDate:contact.updatedAt]];
//  } else if ([[contact objectForKey:@"methodOfLastContact"] isEqual:@"email"]) {
//    self.lastContactedTime.text = [@"Emailed on " stringByAppendingString:[self formatDate:contact.updatedAt]];
//  } else if ([[contact objectForKey:@"methodOfLastContact"] isEqual:@"contacted"]) {
//    self.lastContactedTime.text = [@"Contacted on " stringByAppendingString:[self formatDate:contact.updatedAt]];
//  } else {
//    self.lastContactedTime.text = @" ";
//    self.lastContactedText.hidden = YES;
//    [self addGettingStarted];
//  }
  [self queryParseHistory];
}

- (void)addGettingStarted{
  self.tableView.hidden = YES;
  self.seeMore.hidden = YES;
  self.contactHistoryView.hidden = YES;
  [self addShadowToActions:self.call];
  [self addShadowToActions:self.text];
  [self addShadowToActions:self.email];
  [self addShadowToActions:self.plus];
//  [self.contactHistoryView addSubview:self.started];
}
- (void)addShadowToActions:(UIButton *)button{
  if (button.enabled){
    button.layer.shadowColor = [UIColor colorWithRed:74/255.0f green:149/255.0f blue:203/255.0f alpha:1.0f].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 0);
    button.layer.shadowRadius = 5.0;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:1.0];
    anim.duration = 3.0;
    [button.layer addAnimation:anim forKey:@"shadowOpacity"];
    button.layer.shadowOpacity = 1.0;
  }
}
- (UIImageView *)started{
  if (started == nil){
    started = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"started"]];
  }
  return started;
}

- (void)removeGettingStarted{
  self.tableView.hidden = NO;
  self.seeMore.hidden = NO;
  self.started.hidden = YES;
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)emailButton:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* emailCntrl = [[MFMailComposeViewController alloc] init];
        emailCntrl.mailComposeDelegate = self;
        [emailCntrl setToRecipients:[NSArray arrayWithObject:[contact objectForKey:@"email"]]];
        [self presentViewController:emailCntrl animated:YES completion:nil];
    }
}

- (IBAction)textButton:(id)sender {
	MFMessageComposeViewController *smsCntrl = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		smsCntrl.recipients = [NSArray arrayWithObjects:[contact objectForKey:@"number"], nil];
		smsCntrl.messageComposeDelegate = self;
    [self presentViewController:smsCntrl animated:YES completion:nil];
	}
}

- (IBAction)callButton:(id)sender {
  NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() -"];
  NSString *cleanedNumber = [[[contact objectForKey:@"number"] componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
  
  NSString *URLString = [@"tel://" stringByAppendingString:cleanedNumber];
  NSURL *URL = [NSURL URLWithString:URLString];
  [[UIApplication sharedApplication] openURL:URL];
  [self saveCommunication:@"call"];
}

- (IBAction)markButton:(id)sender {
    [self saveCommunication:@"contacted"];
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
    [newNetwork setObject:contact forKey:@"colleague"];
    [newNetwork setObject:methodOfContact forKey:@"method"];
    [newNetwork saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (succeeded){
        [self queryParseHistory];
      }
    }];
  
    // Save last contact
    [contact setObject:methodOfContact forKey:@"methodOfLastContact"];
    [contact setObject:[NSNumber numberWithBool:YES] forKey:@"notifiedSincePush"];
    [contact saveEventually];

    // Update the app to respect todays communication
    [self loadContactHistory];
    self.lastContactedText.hidden = NO;
    self.lastContactedTime.hidden = NO;
    [SVProgressHUD showSuccessWithStatus:@"Great job at keeping in touch!"];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"contactHistorySegue"]){
    ContactHistoryController *destViewController = segue.destinationViewController;
    destViewController.contact = self.contact;
  }
}
- (void)queryParseHistory{
  PFQuery *query = [PFQuery queryWithClassName:@"ContactHistory"];
  [query whereKey:@"colleague" equalTo:self.contact];
  [query orderByDescending:@"createdAt"];
  query.skip = 1;
  query.limit = 3;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      if (objects.count == 0){
        self.tableView.hidden = YES;
        self.seeMore.hidden = YES;
        [self addGettingStarted];
      } else {
        self.contactHistory = objects;
        [self removeGettingStarted];
        [self.tableView reloadData];
      }
    }
  }];
}
#pragma mark - UITableViewDatasource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.contactHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"contactShowCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  PFObject *history = [self.contactHistory objectAtIndex:indexPath.row];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }
  if ([[history objectForKey:@"method"] isEqual:@"call"]) {
    cell.textLabel.text = [@"Called on " stringByAppendingString:[self formatDate:history.createdAt]];
  } else if ([[history objectForKey:@"method"] isEqual:@"sms"]) {
    cell.textLabel.text = [@"Texted on " stringByAppendingString:[self formatDate:history.createdAt]];
  } else if ([[history objectForKey:@"method"] isEqual:@"email"]) {
    cell.textLabel.text = [@"Emailed on " stringByAppendingString:[self formatDate:history.createdAt]];
  } else if ([[history objectForKey:@"method"] isEqual:@"contacted"]) {
    cell.textLabel.text = [@"Contacted on " stringByAppendingString:[self formatDate:history.createdAt]];
  }
  cell.textLabel.backgroundColor = [UIColor clearColor];
//  cell.imageView.image = [UIImage imageNamed:@"email-gray.png"];
  cell.backgroundView =  [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list-item-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
  return cell;
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
@end
