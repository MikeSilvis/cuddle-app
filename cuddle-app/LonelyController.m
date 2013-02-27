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
    self.navigationItem.hidesBackButton = YES;
}
- (IBAction)showPeoplePicker:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PeoplePicker" object:self];
}
@end
