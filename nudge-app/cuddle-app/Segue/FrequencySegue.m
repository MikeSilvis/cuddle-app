//
//  FrequencySegue.m
//  nudge
//
//  Created by Mike Silvis on 3/20/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "FrequencySegue.h"
#import "QuartzCore/QuartzCore.h"

@implementation FrequencySegue
- (void)perform {
  UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
  UIViewController *destinationController = (UIViewController*)[self destinationViewController];
  
  CATransition* transition = [CATransition animation];
  transition.duration = .75;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
  transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
  
  
  [sourceViewController.navigationController.view.layer addAnimation:transition
    forKey:kCATransition];
  
  [sourceViewController.navigationController pushViewController:destinationController animated:NO];
  
}
@end
