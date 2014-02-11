//
//  RegisterSegue.m
//  nudge
//
//  Created by Mike Silvis on 2/10/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "RegisterSegue.h"

@implementation RegisterSegue
- (void)perform {
	UIViewController *src = (UIViewController *) self.sourceViewController;
	UIViewController *dst = (UIViewController *) self.destinationViewController;
  
	[src.navigationController pushViewController:dst animated:NO];
}
@end
