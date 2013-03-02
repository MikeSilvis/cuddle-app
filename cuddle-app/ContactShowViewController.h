//
//  ContactShowViewController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHistoryCell.h"
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ContactShowViewController : UIViewController  <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *contactPhoto;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet PFObject *contact;

- (IBAction)emailButton:(id)sender;
- (IBAction)textButton:(id)sender;
- (IBAction)callButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *contactHistoryTable;

@end
