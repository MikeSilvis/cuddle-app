//
//  LonelyController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/21/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "LonelyController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation LonelyController

-(void)viewDidLoad{
	[super viewDidLoad];
	self.screenName = @"Lonely Screen";
	self.navigationItem.hidesBackButton = YES;
  self.view.backgroundColor = [UIColor colorWithRed:(175.0/255) green:(218.0/255) blue:(255.0/255) alpha:1.0];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (IBAction)showPeoplePicker:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PeoplePicker" object:self];
	[self.navigationController popViewControllerAnimated:NO];
}

@end
