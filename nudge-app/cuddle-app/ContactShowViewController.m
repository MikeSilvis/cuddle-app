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
//  self.navigationItem.backBarButtonItem
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
  
    [self loadContactPhoto];
    [self disableButtonsWithoutInfo];
    [self loadStyles];
    [self queryParseHistory];
    self.contactName.text = [contact objectForKey:@"name"];

}
- (void)loadStyles{
  self.contactBackground.layer.shadowColor = [UIColor whiteColor].CGColor;
  self.contactBackground.layer.shadowOffset = CGSizeMake(0, 1);
  self.contactBackground.layer.shadowOpacity = 1;
  self.contactBackground.layer.shadowRadius = 5.0;
  self.contactBackground.clipsToBounds = NO;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.layer.borderColor = [UIColor whiteColor].CGColor;
  self.tableView.layer.cornerRadius = 5;
  self.tableView.layer.borderWidth = 2.0;
  self.tableView.clipsToBounds = YES;
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

- (void)addGettingStarted{
  self.tableView.hidden = YES;
  self.seeMore.hidden = YES;
  self.contactHistoryText.hidden = YES;
  [self addShadowToActions:self.call];
  [self addShadowToActions:self.text];
  [self addShadowToActions:self.email];
  [self addShadowToActions:self.plus];
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
  self.contactHistoryText.hidden = NO;
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
//    [self saveCommunication:@"contacted"];
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Method of Communicaiton"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Called", @"Texted", @"Emailed", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
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
    [SVProgressHUD showSuccessWithStatus:@"Great job at keeping in touch!"];
    [self queryParseHistory];
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
#pragma mark - UITableViewDatasource methods

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
  cell.textLabel.text = [self formatDate:history.createdAt];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  if ([[history objectForKey:@"method"] isEqual:@"call"]) {
    cell.imageView.image = [UIImage imageNamed:@"phone-gray.png"];
  } else if ([[history objectForKey:@"method"] isEqual:@"sms"]) {
    cell.imageView.image = [UIImage imageNamed:@"sms-gray.png"];
  } else if ([[history objectForKey:@"method"] isEqual:@"email"]) {
    cell.imageView.image = [UIImage imageNamed:@"envelope-gray.png"];
  } else if ([[history objectForKey:@"method"] isEqual:@"contacted"]) {
      cell.imageView.image = [UIImage imageNamed:@"checkmark-gray.png"];
  }
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
