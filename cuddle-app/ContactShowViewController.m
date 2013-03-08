//
//  ContactShowViewController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactShowViewController.h"

@implementation ContactShowViewController

@synthesize contact;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [contact objectForKey:@"name"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    [self loadContactPhoto];
    [self loadContactHistory];
    [self disableButtonsWithoutInfo];
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
    self.call.enabled= NO;
    self.text.enabled= NO;
  }
  if (([contact objectForKey:@"email"] == nil) || ([[contact objectForKey:@"email"] isEqual: @""])){
    self.email.enabled= NO;
  }
}
- (void)loadContactHistory{
  if ([[contact objectForKey:@"methodOfLastContact"] isEqual:@"call"]) {
    self.lastContacted.text = [@"Called on " stringByAppendingString:[self formatDate:contact.createdAt]];;
  } else if ([[contact objectForKey:@"methodOfLastContact"] isEqual:@"sms"]) {
    self.lastContacted.text = [@"Texted on " stringByAppendingString:[self formatDate:contact.createdAt]];;
  } else if ([[contact objectForKey:@"methodOfLastContact"] isEqual:@"email"]) {
    self.lastContacted.text = [@"Emailed on " stringByAppendingString:[self formatDate:contact.createdAt]];;
  } else {
    self.lastContacted.text = @"Never contacted from Cuddle";
  }
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
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

#pragma mark - MFMailComposeController delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent){
      [self saveCommunication:@"email"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveCommunication:(NSString *)methodOfContact{
  
    // Save the relationship
    PFObject *newNetwork = [[PFObject alloc] initWithClassName:@"ContactHistory"];
    [newNetwork setObject:contact forKey:@"colleague"];
    [newNetwork setObject:methodOfContact forKey:@"method"];
    [newNetwork saveEventually];
  
    // Save last contact
    [contact setObject:methodOfContact forKey:@"methodOfLastContact"];
    [contact saveEventually];

    // Update the app to respect todays communication
    self.lastContacted.text = [self formatDate:[NSDate date]];
    self.lastContacted.hidden = NO;
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
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
    if (result == MessageComposeResultSent){
        [self saveCommunication:@"sms"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"contactHistorySegue"]){
    ContactHistoryController *destViewController = segue.destinationViewController;
    destViewController.contact = self.contact;
  }
}
@end
