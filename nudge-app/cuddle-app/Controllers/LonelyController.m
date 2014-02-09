//
//  LonelyController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/21/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "LonelyController.h"

@implementation LonelyController

-(void)viewDidLoad{
	[super viewDidLoad];
	self.screenName = @"Home Screen";
	self.navigationItem.hidesBackButton = YES;
}
- (IBAction)showPeoplePicker:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PeoplePicker" object:self];
	[self.navigationController popViewControllerAnimated:YES];
}
@end
