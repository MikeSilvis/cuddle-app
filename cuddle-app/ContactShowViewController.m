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
    self.contactPhoto.file = [contact objectForKey:@"photo"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    [self loadContactHistory];
}

- (void)loadContactHistory{
  PFQuery *query = [PFQuery queryWithClassName:@"ContactHistory"];
  [query whereKey:@"colleague" equalTo:self.contact];
  [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (object) {
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"MMM d"];
      NSString *stringFromDate = [formatter stringFromDate:object.createdAt];
      self.lastContacted.text = stringFromDate;
      if ([[object objectForKey:@"method"] isEqual: @"call"]){
        self.lastContactedImage.image = [UIImage imageNamed:@"phone-gray.png"];
      } else if ([[object objectForKey:@"method"] isEqual: @"sms"]){
        self.lastContactedImage.image = [UIImage imageNamed:@"sms-gray.png"];
      } else if([[object objectForKey:@"method"] isEqual: @"email"]){
        self.lastContactedImage.image = [UIImage imageNamed:@"envelope-gray.png"];
      }
    } else {
      self.lastContactedButton.hidden = YES;
      self.lastContacted.hidden = YES;
      self.lastContactedImage.hidden = YES;
    }
  }];
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
  [self saveCommunication:@"call"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[contact objectForKey:@"number"]]];
}

#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
//    if (result == MFMailComposeResultSent){
    [self saveCommunication:@"email"];
//    }
//	switch (result)
//	{
//		case MFMailComposeResultCancelled:
//			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
//			break;
//		case MFMailComposeResultSaved:
//			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
//			break;
//		case MFMailComposeResultSent:
//			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
//			break;
//		case MFMailComposeResultFailed:
//			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
//			break;
//		default:
//			NSLog(@"Mail not sent");
//			break;
//	}
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveCommunication:(NSString *)methodOfContact{
    PFObject *newNetwork = [[PFObject alloc] initWithClassName:@"ContactHistory"];
    [newNetwork setObject:contact forKey:@"colleague"];
    [newNetwork setObject:methodOfContact forKey:@"method"];
    [newNetwork saveEventually];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
//    if (result == MessageComposeResultSent){
        [self saveCommunication:@"sms"];
//    }
//	switch (result) {
//		case MessageComposeResultCancelled:
//			NSLog(@"Cancelled");
//			break;
//		case MessageComposeResultFailed:
//			NSLog(@"Failed");
//			break;
//		case MessageComposeResultSent:
//			NSLog(@"Send");
//			break;
//		default:
//			break;
//	}
	
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
