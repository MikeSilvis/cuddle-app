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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "SVProgressHUD.h"
#import  <QuartzCore/QuartzCore.h> 
#import <QuartzCore/CAAnimation.h>

@interface ContactShowViewController : UIViewController  <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *contactPhoto;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet PFObject *contact;

- (IBAction)emailButton:(id)sender;
- (IBAction)textButton:(id)sender;
- (IBAction)callButton:(id)sender;
- (IBAction)markButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *call;
@property (weak, nonatomic) IBOutlet UIButton *text;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UIImageView *contactBackground;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contactHistoryView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;

@property (weak, nonatomic) IBOutlet UILabel *lastContactedTime;
@property (weak, nonatomic) IBOutlet UILabel *lastContactedText;

@property (nonatomic, retain) NSArray *contactHistory;
@property (weak, nonatomic) IBOutlet UIButton *seeMore;

@property (strong, nonatomic) IBOutlet UIImageView *started;
@end
