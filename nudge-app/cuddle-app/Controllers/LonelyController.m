//
//  LonelyController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/21/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "LonelyController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FrequencyPickerNavigationControllerViewController.h"

@implementation LonelyController

-(void)viewDidLoad{
	[super viewDidLoad];
	self.screenName = @"Lonely Screen";
	self.navigationItem.hidesBackButton = YES;

  self.view.backgroundColor = [UIColor colorWithRed:(175.0/255) green:(218.0/255) blue:(255.0/255) alpha:1.0];
}

-(void)viewDidAppear:(BOOL)animated {
//  if (self.lastAddedColleague) {
//    [self.navigationController popViewControllerAnimated:NO];
//  }
  [super viewDidAppear:animated];
}

- (IBAction)showPeoplePicker:(id)sender {
  CFErrorRef error;
  ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
  ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
  });
}

- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
  [SVProgressHUD showWithStatus:@"Saving Contact" maskType:SVProgressHUDMaskTypeBlack];

  self.lastAddedColleague = [[Colleague alloc] initWithABPerson:person];

  [SVProgressHUD dismiss];
  
  [PFAnalytics trackEvent:@"contactAdded" dimensions:@{@"contactAdded":@"true"}];
  [peoplePicker dismissViewControllerAnimated:NO completion:^{
    [self performSegueWithIdentifier:@"LonelyFrequencyPickerSegue" sender:self];
  }];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
  return NO;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([segue.identifier isEqualToString:@"LonelyFrequencyPickerSegue"]) {
      FrequencyPickerNavigationControllerViewController *destViewController = segue.destinationViewController;
      destViewController.contact = self.lastAddedColleague;
  }
}

@end
