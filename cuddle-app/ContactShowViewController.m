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
  [query findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error) {
    if (!error) {
      [self.contactHistoryTable reloadData];
      NSLog(@"Successfully retrieved %d scores.", object.count);
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
        [emailCntrl setToRecipients:[NSArray arrayWithObject:@"user@gmail.com"]];
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
		smsCntrl.body = @"Hello Friends this is sample text message.";
		smsCntrl.recipients = [NSArray arrayWithObjects:@"+8145746139", nil];
		smsCntrl.messageComposeDelegate = self;
        [self presentViewController:smsCntrl animated:YES completion:nil];
	}
}

- (IBAction)callButton:(id)sender {
    [self saveCommunication:@"call"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"+8145746139"]];
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
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////  return self.beers.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
  NSLog(@"never here");
  ContactHistoryCell *cell = (ContactHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"contactHistoryCell"];
  cell.lastContacted.text = @"HEYO";
  cell.typeOfContact.image = [UIImage imageNamed:@"sms.png"];
//  ContactInfoCell *cell = (ContactInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
//  cell.userName.text = [object objectForKey:@"name"];
//  PFFile *photo = [object objectForKey:@"photo"];
//  
//  cell.userPicture.layer.cornerRadius = 5;
//  cell.userPicture.clipsToBounds = YES;
//  
//  if (photo){
//    cell.userPicture.file = photo;
//    [cell.userPicture loadInBackground];
//  } else{
//    cell.userPicture.image = [UIImage imageNamed:@"contact_without_image@2x.png"];
//  }
  
  return cell;
}
@end
