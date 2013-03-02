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
//    PFObject *history = [contact objectForKey:@"parent"];
//    [history fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
////        NSString *title = [post objectForKey:@"title"];
//        NSLog(@"%@", history);
//    }];
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
//        [emailCntrl setSubject:@"iPhone Email Example Mail"];
//        [emailCntrl setMessageBody:@"http://iphoneapp-dev.blogspot.com" isHTML:NO];
        
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
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"+8145746139"]];
}

#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Failed");
			break;
		case MessageComposeResultSent:
			NSLog(@"Send");
			break;
		default:
			break;
	}
	
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
