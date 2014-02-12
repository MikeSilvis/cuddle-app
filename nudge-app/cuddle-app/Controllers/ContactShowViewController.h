//
//  ContactShowViewController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHistoryController.h"
#import <Parse/Parse.h>
#import "Colleague.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "SVProgressHUD.h"
#import  <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>
#import "FrequencyPickerController.h"
#import "GAITrackedViewController.h"

@interface ContactShowViewController : GAITrackedViewController  <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *contactPhoto;
@property (strong, nonatomic) IBOutlet Colleague *contact;


@property (weak, nonatomic) IBOutlet UIImageView *NudgeTooltips;
- (IBAction)callButton:(id)sender;
- (IBAction)textButton:(id)sender;
- (IBAction)emailButton:(id)sender;
- (IBAction)markButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *call;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *text;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *email;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plus;


- (IBAction)editFrequency:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *contactHistory;
@property (weak, nonatomic) IBOutlet UIButton *seeMore;
@end
