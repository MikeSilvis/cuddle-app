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

@interface ContactShowViewController : UIViewController  <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *contactPhoto;
@property (strong, nonatomic) IBOutlet Colleague *contact;

- (IBAction)emailButton:(id)sender;
- (IBAction)textButton:(id)sender;
- (IBAction)callButton:(id)sender;
- (IBAction)markButton:(id)sender;
- (IBAction)editFrequency:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *call;
@property (weak, nonatomic) IBOutlet UIButton *text;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contactHistoryView;

@property (nonatomic, retain) NSArray *contactHistory;
@property (weak, nonatomic) IBOutlet UILabel *contactHistoryText;
@property (weak, nonatomic) IBOutlet UIButton *seeMore;
@end
