//
//  LoginSegue.m
//  nudge
//
//  Created by Mike Silvis on 2/8/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "LoginSegue.h"

@implementation LoginSegue
- (void)perform {
	UIViewController *src = (UIViewController *) self.sourceViewController;
	UIViewController *dst = (UIViewController *) self.destinationViewController;
  
	[src.navigationController pushViewController:dst animated:NO];
}
@end
